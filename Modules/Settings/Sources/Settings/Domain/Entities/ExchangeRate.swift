//
//  ExchangeRate.swift
//  Settings — Domain
//
//  ExchangeRates has been moved to the Common module so that CurrencyStore
//  (which also lives in Common) can reference it without a circular dependency.
//
//  This typealias re-exports the type so all existing code in Settings that
//  imports only Settings — and not Common explicitly — continues to compile
//  with no changes required.
//

import Common

// Re-export from Common so all Settings call-sites keep working.
public typealias ExchangeRates = Common.ExchangeRates
