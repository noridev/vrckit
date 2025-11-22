//
//  CookieManager.swift
//  VRCKit
//
//  Created by makinosp on 2024/07/03.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import MemberwiseInit

public final actor CookieManager {
    private var domainURL: String
    private let credentialsPath: URL
    private var isLoaded = false

    init(domainURL: String) {
        self.domainURL = domainURL
        let fileManager = FileManager.default
        #if os(iOS) || os(watchOS) || os(tvOS)
        let baseDirectory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let configDir = baseDirectory.appendingPathComponent("vrckit")
        #else
        let configDir = fileManager.homeDirectoryForCurrentUser
            .appendingPathComponent(".config")
            .appendingPathComponent("vrckit")
        #endif
        self.credentialsPath = configDir.appendingPathComponent("credentials.json")
        Task { await self.loadCookies() }
    }

    /// Ensures cookies are loaded before proceeding
    public func ensureLoaded() {
        guard !isLoaded else { return }
        loadCookies()
    }

    /// Retrieves the cookies stored for the VRChat API domain.
    /// - Returns: An array of `HTTPCookie` objects.
    public var cookies: [HTTPCookie] {
        guard let url = URL(string: domainURL),
              let cookies = HTTPCookieStorage.shared.cookies(for: url) else { return [] }
        return cookies
    }

    /// Deletes all cookies stored for the VRChat API domain.
    public func deleteCookies() {
        cookies.forEach { HTTPCookieStorage.shared.deleteCookie($0) }
        do {
            try FileManager.default.removeItem(at: credentialsPath)
        } catch {
            // Ignore error if file doesn't exist
        }
    }

    public var cookieExists: Bool { !cookies.isEmpty }

    var httpField: [String: String] {
        HTTPCookie.requestHeaderFields(with: cookies)
    }

    func saveCookies() throws {
        let serializableCookies = cookies.map(SerializableCookie.init)
        let data = try JSONEncoder().encode(serializableCookies)
        let directory = credentialsPath.deletingLastPathComponent()
        if !FileManager.default.fileExists(atPath: directory.path) {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        }
        try data.write(to: credentialsPath)
        print("[CookieManager] Saved \(serializableCookies.count) cookies to \(credentialsPath.path)")
        serializableCookies.forEach { cookie in
            print("[CookieManager] Saved cookie: \(cookie.name) (expires: \(cookie.expiresDate?.description ?? "session"))")
        }
    }

    private func loadCookies() {
        defer { isLoaded = true }

        guard FileManager.default.fileExists(atPath: credentialsPath.path) else {
            print("[CookieManager] No saved cookies found at \(credentialsPath.path)")
            return
        }
        do {
            let data = try Data(contentsOf: credentialsPath)
            let serializableCookies = try JSONDecoder().decode([SerializableCookie].self, from: data)
            print("[CookieManager] Loading \(serializableCookies.count) cookies")
            serializableCookies.forEach { cookie in
                if let httpCookie = cookie.toHTTPCookie() {
                    HTTPCookieStorage.shared.setCookie(httpCookie)
                    print("[CookieManager] Loaded cookie: \(cookie.name) (expires: \(cookie.expiresDate?.description ?? "session"))")
                }
            }
        } catch {
            print("[CookieManager] Failed to load cookies: \(error)")
        }
    }
}
