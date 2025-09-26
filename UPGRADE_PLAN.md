# ntfy-iOS Modernisierung & Markdown Support - Upgrade Plan

## Projektziel
Fork des ntfy-iOS Projekts modernisieren und Markdown-Support hinzufügen, damit URLs klickbar werden und Nachrichten besser formatiert sind.

## Phase 1: Grundlegende Modernisierung

### 1.1 Project Analysis & Initial Setup
- [ ] Xcode öffnen und automatische Migration Vorschläge prüfen
- [ ] Backup des originalen Projektstands erstellen
- [ ] Build-Fehler dokumentieren

### 1.2 Swift & iOS Version Updates
- [ ] **Swift Version:** 5.0 → 5.9
  - In Build Settings für alle Targets anpassen
  - Compiler Warnings beheben
- [ ] **iOS Deployment Target:** 14.0 → 17.0
  - Bessere Balance zwischen Features und Nutzerreichweite
  - iOS 17 ist weit verbreitet (über 70% der Geräte)

### 1.3 API Migrations
- [ ] Deprecated APIs identifizieren und ersetzen
  - UIKit deprecated Methoden
  - SwiftUI API Updates
  - Notification APIs
- [ ] Von `ObservableObject` zu `@Observable` macro (iOS 17+)
  - Modernere State Management
  - Bessere Performance

## Phase 2: Markdown Integration

### 2.1 Dependencies Setup
- [ ] Swift Package Manager (SPM) Integration hinzufügen
- [ ] MarkdownUI Library hinzufügen:
  ```swift
  .package(url: "https://github.com/gonzalezreal/MarkdownUI", from: "2.0.0")
  ```

### 2.2 Markdown Detection Logic
- [ ] Header-basierte Erkennung implementieren:
  - Check für `X-Markdown: yes` Header
  - Optional: Auto-Detection bei URLs/Code-Blöcken
- [ ] User Setting für Default-Verhalten

### 2.3 UI Implementation
- [ ] `MarkdownView` Component erstellen
- [ ] `NotificationListView` anpassen:
  ```swift
  if notification.isMarkdown {
      MarkdownView(content: notification.message)
  } else {
      Text(notification.message)
  }
  ```
- [ ] Link-Handling konfigurieren (in-app vs. Safari)

### 2.4 Settings Integration
- [ ] Toggle für Markdown-Rendering in Settings
- [ ] Option für Auto-Detection
- [ ] Link-Handling Präferenzen

## Phase 3: Notification Service

### 3.1 NotificationService Extension Update
- [ ] iOS 17 Notification APIs verwenden
- [ ] Rich Notifications mit Markdown Preview
- [ ] Attachment Handling modernisieren

### 3.2 Testing
- [ ] Push Notifications mit Markdown Content
- [ ] Local Notifications
- [ ] Background Refresh

## Phase 4: Final Polish

### 4.1 Testing
- [ ] iOS 17 Device Testing
- [ ] iOS 18 Device Testing
- [ ] Dark Mode Compatibility
- [ ] Dynamic Type Support

### 4.2 Performance
- [ ] Memory Usage prüfen
- [ ] Rendering Performance optimieren
- [ ] Battery Impact testen

## Technische Details

### Dependencies
- **MarkdownUI 2.0+** - SwiftUI native Markdown rendering
- Alternative: **Down** - Falls mehr Kontrolle nötig

### Minimum Requirements
- iOS 17.0+
- Swift 5.9
- Xcode 15.0+

### Key Files zu bearbeiten
1. `ntfy.xcodeproj/project.pbxproj` - Version Updates
2. `NotificationListView.swift` - Markdown Rendering
3. `NotificationContent.swift` - Markdown Detection
4. `SettingsView.swift` - User Preferences
5. `NotificationService.swift` - Extension Updates

## Notizen
- Keine Breaking Changes für bestehende User
- Markdown ist opt-in via Header oder Setting
- Fallback zu Plain Text immer verfügbar
- URLs werden automatisch klickbar bei Markdown=yes