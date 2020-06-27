//
//  WKWebViewSwiftUI.swift
//  Fellowship
//
//  Created by Zhengqian Kuang on 2019-10-12.
//  Copyright © 2019 Zhengqian Kuang. All rights reserved.
//

import SwiftUI
import UIKit
import WebKit

public enum JKCSWKWebViewEvent: String {
    case wordClickHandler
}

public protocol JKCSWKWebViewEventDelegate {
    func didHappen(event: JKCSWKWebViewEvent, info: Any?)
}

public extension JKCSWKWebViewEventDelegate {
    func didHappen(event: JKCSWKWebViewEvent, info: Any?) {
        //
    }
}

// iOS WKWebView Communication Using Javascript and Swift
//  - https://medium.com/john-lewis-software-engineering/ios-wkwebview-communication-using-javascript-and-swift-ee077e0127eb

// https://www.hackingwithswift.com/quick-start/swiftui/how-to-wrap-a-custom-uiview-for-swiftui
// https://www.hackingwithswift.com/articles/112/the-ultimate-guide-to-wkwebview

public struct JKCSWKWebView: UIViewRepresentable {
    let postMessageHandlers: [JKCSWKWebViewEvent]?
    let wkWebViewWrapper = WKWebViewWrapper()
    let delegate: JKCSWKWebViewEventDelegate?
    
    public init(postMessageHandlers: [JKCSWKWebViewEvent]? = nil, delegate: JKCSWKWebViewEventDelegate? = nil) {
        self.postMessageHandlers = postMessageHandlers
        wkWebViewWrapper.createWKWebView(postMessagehandlers: postMessageHandlers, delegate: delegate)
        self.delegate = delegate
    }
    
    public func makeUIView(context: UIViewRepresentableContext<JKCSWKWebView>) -> WKWebView {
        return wkWebViewWrapper.wrappedValue(postMessageHandlers: postMessageHandlers, delegate: delegate)
    }
    
    public func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<JKCSWKWebView>) {
        //
    }
    
    @discardableResult public func load(urlString: String) -> Self {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            wkWebViewWrapper.wrappedValue().load(request)
        }
        return self
    }
    
    /**
     * loadFile(resource: "index", ext: "html") - to load index.html
     */
    @discardableResult public func loadFile(resource: String? = nil, ext: String? = nil) -> Self {
        if let url = Bundle.main.url(forResource: resource, withExtension: ext) {
            // url.deletingLastPathComponent() part tells WebKit it can read from the directory that contains help.html – that’s a good place to put any assets such as images, JavaScript, or CSS.
            wkWebViewWrapper.wrappedValue().loadFileURL(url, allowingReadAccessTo: url.deletingPathExtension())
        }
        return self
    }
    
    @discardableResult public func loadHTMLString(htmlString: String, baseURLString: String? = nil) -> Self {
        var baseURL: URL? = nil
        if let baseURLString = baseURLString {
            guard let url = URL(string: baseURLString) else {
                return self
            }
            baseURL = url
        }
        wkWebViewWrapper.wrappedValue().loadHTMLString(htmlString, baseURL: baseURL)
        return self
    }
    
    @discardableResult public func evaluateJavaScript(javaScriptString: String, completionHandler: ((Any?, Error?) -> Void)?) -> Self {
        wkWebViewWrapper.wrappedValue().evaluateJavaScript(javaScriptString) { (result, error) in
            if let completionHandler = completionHandler {
                completionHandler(result, error)
            }
        }
        return self
        
        // e.g.
        // if you had a page that contained <div id="username">@twostraws</div>,
        // you would use "document.getElementById('username').innerText" as javaScriptString
        // and the result would be "@twostraws"
    }
    
    public func backList() -> [WKBackForwardListItem] {
        return wkWebViewWrapper.wrappedValue().backForwardList.backList
    }
    
    public func forwardList() -> [WKBackForwardListItem] {
        return wkWebViewWrapper.wrappedValue().backForwardList.forwardList
    }
    
    @discardableResult public func handleCookiesExample() -> Self {
        // As an example, this code loops over all cookies, and when it finds one called “authentication” deletes it – all other cookies are just printed out
        wkWebViewWrapper.wrappedValue().configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
            for cookie in cookies {
                if cookie.name == "authentication" {
                    self.wkWebViewWrapper.wrappedValue().configuration.websiteDataStore.httpCookieStore.delete(cookie)
                } else {
                    print("\(cookie.name) is set to \(cookie.value)")
                }
            }
        }
        return self
    }
    
    @discardableResult public func takeSnapshot(rect: CGRect, completionHandler: @escaping (UIImage?, Error?) -> Void) -> Self {
        let config = WKSnapshotConfiguration()
        config.rect = rect
        wkWebViewWrapper.wrappedValue().takeSnapshot(with: config) { (image, error) in
            completionHandler(image, error)
        }
        return self
    }

    class WKWebViewWrapper: UIViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
        private var wkWebView: WKWebView? = nil
        private var delegate: JKCSWKWebViewEventDelegate? = nil
        
        @discardableResult func createWKWebView(postMessagehandlers: [JKCSWKWebViewEvent]? = nil, delegate: JKCSWKWebViewEventDelegate? = nil) -> WKWebView {
            let config = WKWebViewConfiguration()
            // config.preferences.javaScriptEnabled = true
            // config.dataDetectorTypes = [.address, .calendarEvent, .flightNumber, .link, .lookupSuggestion, .phoneNumber, .trackingNumber]
            // wkWebView = WKWebView(frame: .zero, configuration: config)
            if let postMessagehandlers = postMessagehandlers {
                for postMessagehandler in postMessagehandlers {
                    config.userContentController.add(self, name: postMessagehandler.rawValue)
                }
            }
            
            wkWebView = WKWebView(frame: .zero, configuration: config)
            wkWebView?.navigationDelegate = self
            wkWebView?.uiDelegate = self
            
            wkWebView?.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
            wkWebView?.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)
            
            self.delegate = delegate
            
            return wkWebView!
        }
        
        func wrappedValue(postMessageHandlers: [JKCSWKWebViewEvent]? = nil, delegate: JKCSWKWebViewEventDelegate? = nil) -> WKWebView {
            if wkWebView == nil {
                createWKWebView(postMessagehandlers: postMessageHandlers, delegate: delegate)
            }
            return wkWebView!
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            // if let url = navigationAction.request.url {
                // check url and
                //   decisionHandler(.cancel)
                // to cancel
            // }
            decisionHandler(.allow)
        }
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == JKCSWKWebViewEvent.wordClickHandler.rawValue {
                guard
                    let body = message.body as? [String: Any],
                    let param1 = body["param1"] as? String
                else {
                    return
                }
                print("clicked word: \(param1)")
                delegate?.didHappen(event: .wordClickHandler, info: param1)
            }
        }
        
//        func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
//            // let ac = UIAlertController(title: "Hey, listen!", message: message, preferredStyle: .alert)
//            // ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            // present(ac, animated: true)
//            completionHandler()
//        }
//
//        func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
//            // show confirm panel
//            completionHandler(true or false according to the confirm panel)
//        }
//
//        func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
//            // show text input panel
//            completionHandler(text according to the input panel)
//        }
        
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "estimatedProgress" {
                // print(Float(wkWebView!.estimatedProgress))
            }
            else if keyPath == "title" {
                // if let title = wkWebView?.title {
                    //
                // }
            }
        }
    }
}
