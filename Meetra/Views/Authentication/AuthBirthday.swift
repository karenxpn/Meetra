//
//  AuthBirthday.swift
//  Meetra
//
//  Created by Karen Mirakyan on 03.03.22.
//

import SwiftUI
import Combine

enum BirthdayForm: Hashable {
    case day
    case month
    case year
}

struct AuthBirthday: View {
    @State var model: RegistrationRequest
    
    @ObservedObject var birthdayFormFields = BirthdayFormFields()
    @FocusState private var focusedField: BirthdayForm?
    @State private var navigate: Bool = false
    
    var body: some View {
        ZStack {
            VStack( alignment: .leading, spacing: 30) {
                
                Text("Ваш день\nрождения:")
                    .foregroundColor(.black)
                    .font(.custom("Inter-SemiBold", size: 30))
                
                
                Text( "Остальные увидят только\nваш возраст" )
                    .foregroundColor(.black)
                    .font(.custom("Inter-Regular", size: 16))
                
                HStack {
                    BirthdayFields(placeholder: "ДД", width: 61, date: $birthdayFormFields.day)
                        .focused($focusedField, equals: .day)
                    
                    BirthdayFields(placeholder: "ММ", width: 61, date: $birthdayFormFields.month)
                        .focused($focusedField, equals: .month)
                    
                    
                    BirthdayFields(placeholder: "ГГГГ", width: 72, date: $birthdayFormFields.year)
                        .focused($focusedField, equals: .year)
                }
                
                
                
                Spacer()
                
                
                Button {
                    model.birthday = "\(birthdayFormFields.day)/\(birthdayFormFields.month)/\(birthdayFormFields.year)"
                    navigate.toggle()
                } label: {
                    HStack {
                        Spacer()
                        
                        Text( "Продолжить" )
                            .font(.custom("Inter-SemiBold", size: 20))
                            .foregroundColor(.white)
                            .padding(.vertical, 15)
                        
                        Spacer()
                    }.background(AppColors.proceedButtonColor)
                        .opacity(!birthdayFormFields.isProceedButtonClickable ? 0.5 : 1)
                        .cornerRadius(30)
                }.disabled(!birthdayFormFields.isProceedButtonClickable)
                    .background(
                        NavigationLink(destination: AuthGenderPicker(model: model), isActive: $navigate, label: {
                            EmptyView()
                        }).hidden()
                    )
                
            }.frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
                .padding(30)
            
            AuthProgress(page: 1)
        }.navigationBarTitle("", displayMode: .inline)
            .onChange(of: birthdayFormFields.day) { value in
                if value.count == 2 {
                    focusedField = .month
                }
            }.onChange(of: birthdayFormFields.month) { value in
                if value.count == 2 {
                    focusedField = .year
                }
            }.onChange(of: birthdayFormFields.year) { value in
                if value.count == 4 {
                    focusedField = nil
                }
            }
    }

}

struct AuthBirthday_Previews: PreviewProvider {
    static var previews: some View {
        AuthBirthday(model: RegistrationRequest())
    }
}


class BirthdayFormFields: ObservableObject {
    let cur_year = Calendar.current.component(.year, from: Date())

    @Published var day: String = ""
    @Published var month: String = ""
    @Published var year: String = ""
    
    private var cancellableSet: Set<AnyCancellable> = []
    @Published var isProceedButtonClickable: Bool = false
    
    init() {
        allPublishersValid
            .receive(on: RunLoop.main)
            .assign(to: \.isProceedButtonClickable, on: self)
            .store(in: &cancellableSet)
    }
    
    
    private var isDayPublisherValid: AnyPublisher<Bool, Never> {
        $day
            .map { $0.count == 2 && Int($0) ?? 0 < 32}
            .eraseToAnyPublisher()
    }
    
    private var isMonthPublisherValid: AnyPublisher<Bool, Never> {
        $month
            .map { $0.count == 2 && Int($0) ?? 0 < 13}
            .eraseToAnyPublisher()
    }
    
    private var isYearPublisherValid: AnyPublisher<Bool, Never> {
        $year
            .map { $0.count == 4 && Int($0) ?? 0 <= self.cur_year - 18}
            .eraseToAnyPublisher()
    }
    
    private var allPublishersValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(isDayPublisherValid, isMonthPublisherValid, isYearPublisherValid)
            .map{ a, b, c in
                return a && b && c
            }.eraseToAnyPublisher()
    }
}
