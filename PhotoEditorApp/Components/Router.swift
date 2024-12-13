//
//  Router.swift
//  PhotoEditorApp
//
//  Created by Bilol Sanatillayev on 02/08/24.
//

import SwiftUI

open class Router: ObservableObject {

    /// Состояние навигации
    struct State {
        var coverSheet: AnyView?
        var navigating: AnyView?
        var presentingSheet: AnyView?
        var alert: AnyView?
        var presentationType: Binding<Bool>
    }

    @Published private(set) var state: State

    init(presentationType: Binding<Bool>) {
        state = State(presentationType: presentationType)
    }
}

extension Router {

    /// Для перехода к другой вью черeз навигейшн
    func navigateTo<V: View>(_ view: V) {
        state.navigating = AnyView(view)
    }
    /// Показ листа поверх контента
    func presentSheet<V: View>(_ view: V) {
        state.presentingSheet = AnyView(view)
    }
    func coverSheet<V: View>(_ view: V) {
        state.coverSheet = AnyView(view)
    }
    func presentAlert<V: View>(_ view: V) {
        state.alert = AnyView(view)
    }
    /// убрать экран
    func dismiss() {
        state.presentationType.wrappedValue = false
    }
}

extension Router {

    var isNavigating: Binding<Bool> {
        boolBinding(keyPath: \.navigating)
    }
    var isCover: Binding<Bool> {
        boolBinding(keyPath: \.coverSheet)
    }
    var isPresentingSheet: Binding<Bool> {
        boolBinding(keyPath: \.presentingSheet)
    }
    var isPresentingAlert: Binding<Bool> {
        boolBinding(keyPath: \.alert)
    }
    var isPresented: Binding<Bool> {
        state.presentationType
    }
}

private extension Router {

    func binding<T>(keyPath: WritableKeyPath<State, T>) -> Binding<T> {
        Binding(
            get: { self.state[keyPath: keyPath] },
            set: { self.state[keyPath: keyPath] = $0 }
        )
    }

    func boolBinding<T>(keyPath: WritableKeyPath<State, T?>) -> Binding<Bool> {
        Binding(
            get: { self.state[keyPath: keyPath] != nil },
            set: {
                if !$0 {
                    self.state[keyPath: keyPath] = nil
                }
            }
        )
    }
}

extension View {

    func navigation(_ router: Router) -> some View {
        self.modifier(NavigationModifier(presentingView: router.binding(keyPath: \.navigating)))
    }
    
    func sheet(_ router: Router) -> some View {
        self.modifier(SheetModifier(presentingView: router.binding(keyPath: \.presentingSheet)))
    }
    
    func cover(_ router: Router) -> some View {
        self.modifier(CoverModifier(presentingView: router.binding(keyPath: \.coverSheet)))
    }
    func alert(_ router: Router) -> some View {
        self.modifier(AlertModifier(presentingView: router.binding(keyPath: \.alert)))
    }
}
