//
//  Localizable.swift
//  AppRentameYA
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(with arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}

// Claves de localización
enum LocalizedKey: String {
    // Welcome Screen
    case appName = "app_name"
    case welcomeSubtitle = "welcome_subtitle"
    
    // Navigation
    case inicio = "inicio"
    case vehiculos = "vehiculos"
    case perfil = "perfil"
    
    // Home Screen
    case helloDriver = "hello_driver"
    case welcomeMessage = "welcome_message"
    case myApplications = "my_applications"
    case noApplications = "no_applications"
    case readyToStart = "ready_to_start"
    case readyToStartMessage = "ready_to_start_message"
    case ourBenefits = "our_benefits"
    case benefit1 = "benefit_1"
    case benefit2 = "benefit_2"
    case benefit3 = "benefit_3"
    
    // Profile
    case myProfile = "my_profile"
    case user = "user"
    case administrator = "administrator"
    case reviewApplications = "review_applications"
    case addVehicle = "add_vehicle"
    case signOut = "sign_out"
    
    // Form
    case applyFor = "apply_for"
    case completeData = "complete_data"
    case fullName = "full_name"
    case namePlaceholder = "name_placeholder"
    case phoneContact = "phone_contact"
    case phonePlaceholder = "phone_placeholder"
    case phoneDigits = "phone_digits"
    case driverLicense = "driver_license"
    case depositBanner = "deposit_banner"
    case depositTitle = "deposit_title"
    case termsAgreement = "terms_agreement"
    case mustAcceptTerms = "must_accept_terms"
    case sendApplication = "send_application"
    case sending = "sending"
    case alreadyHasApplication = "already_has_application"
    case canApplyOtherVehicles = "can_apply_other_vehicles"
    
    // Application Status
    case pending = "pending"
    case inReview = "in_review"
    case approved = "approved"
    case rejected = "rejected"
    
    // Application Sent
    case applicationSent = "application_sent"
    case applicationSentMessage = "application_sent_message"
    case backToVehicles = "back_to_vehicles"
    
    // Admin
    case rentalApplications = "rental_applications"
    case noApplicationsFound = "no_applications_found"
    case loadingApplications = "loading_applications"
    case approve = "approve"
    case reject = "reject"
    case viewLicense = "view_license"
    case vehicle = "vehicle"
    
    // Add Vehicle
    case addNewVehicle = "add_new_vehicle"
    case vehicleName = "vehicle_name"
    case vehicleNamePlaceholder = "vehicle_name_placeholder"
    case pricePerWeek = "price_per_week"
    case pricePlaceholder = "price_placeholder"
    case characteristics = "characteristics"
    case addCharacteristicHint = "add_characteristic_hint"
    case characteristicPlaceholder = "characteristic_placeholder"
    case saveVehicle = "save_vehicle"
    case saving = "saving"
    case close = "close"
    
    // Common
    case week = "week"
    case applyNow = "apply_now"
    
    // Errors
    case error = "error"
    case ok = "ok"
    case pleaseUploadLicense = "please_upload_license"
    case errorSavingVehicle = "error_saving_vehicle"
    case onlyAdminsCanAddVehicles = "only_admins_can_add_vehicles"
    case priceMustBeValid = "price_must_be_valid"
    case unauthorizedUser = "unauthorized_user"
    case errorConvertingImage = "error_converting_image"
    case errorUploadingImage = "error_uploading_image"
    
    var localized: String {
        return self.rawValue.localized
    }
}

