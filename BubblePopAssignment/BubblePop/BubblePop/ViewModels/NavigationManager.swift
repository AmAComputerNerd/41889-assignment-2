//
//  NavigationManager.swift
//  BubblePop
//
//  Created by Jonathon Thomson on 27/4/2025.
//

import Foundation
import SwiftUI

class NavigationManager: ObservableObject {
    @Published var currentView: AnyView = AnyView(HomeView());
    @Published var supportsNavigation: Bool = true;
    
    // ViewFactories for views with a default constructor.
    private let viewFactories: [String: () -> AnyView] = [
        Reflection.getClassName(type: HomeView.self): { AnyView(HomeView()) },
        Reflection.getClassName(type: GameSettingsView.self): { AnyView(GameSettingsView()) },
        Reflection.getClassName(type: GameView.self): { AnyView(GameView()) },
        Reflection.getClassName(type: HighScoreView.self): { AnyView(HighScoreView()) }
    ]
    
    func navigate(to: Any.Type? = nil, withParams: (() -> AnyView)? = nil, supportsNavigation: Bool = false) {
        self.supportsNavigation = supportsNavigation;
        // If Navigation is provided with a closure:
        if let factory = withParams {
            currentView = factory();
            return;
        // Otherwise, if navigation is provided with a name:
        } else if let viewType = to {
            let viewName = Reflection.getClassName(type: viewType);
            if let genericViewFactory = viewFactories[viewName] {
                currentView = genericViewFactory();
                return;
            }
        }
        // Else, if no conditions fit, show a blank page with text to let the user know.
        currentView = AnyView(Text("404: View not found"));
    }
}
