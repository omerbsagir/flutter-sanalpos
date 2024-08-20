
# Sanal POS Uygulaması

## Genel Bakış

UYARI: Uygulama, NFC aracılığıyla alınan tag'lerin içeriğini yalnızca null olup olmadığını kontrol etmektedir. İlgili veriler, herhangi bir banka veya başka bir kuruluşun endpointlerine gönderilmemekte, yalnızca mocklanmış bir şekilde işlem görmektedir. Bu kısmı isterseniz kendi ihtiyaçlarınıza göre geliştirebilir ve gerçek veri işleme ekleyebilirsiniz!!

Bu uygulama, **Flutter** ile geliştirilmiş bir sanal POS projesidir. Uygulama, şirket sahipleri ve çalışanları için iki farklı yetki seviyesi sunar: **Admin** ve **User**. Authentication ve Yetkilendirme (Authorization) işlemleri **JWT** tokenları ile gerçekleştirilir. **User** rolüne sahip hesapları yalnızca **Admin** rolündeki kullanıcılar, uygulamanın **Şirketim** menüsünden kayıt edebilir.

## Admin Rolü

**Admin** rolüne sahip kullanıcılar için uygulamada beş ana menü bulunmaktadır:

1. **Home**: Bu menü NFC ödemeleri almak için kullanılır. Ödeme alabilmek için bir şirket kayıt etmeniz ve şirketinizin aktif olması gerekmektedir. Aktivasyon durumunu belirlemeniz için ise databaseden (dynamoDB) ilgili tablonun ilgili değişkenini true veya false olarak değiştirmek gereklidir.

2. **Şirketim**: Buradan bir şirket oluşturabilir, mevcut şirketinizin detaylarını görebilir ve çalışan hesabı kayıt edebilirsiniz.

3. **Aktivasyon**: Şirketinizi kaydettikten sonra ödeme alabilmek için bir aktivasyon oluşturmanız gerekir. Eğer halihazırda bir aktivasyon başvurusu varsa, bu menüde aktivasyon durumu gösterilir.

4. **Cüzdanım**: Şirketinizi oluştururken belirttiğiniz IBAN'a gelen ödemelerin detaylarını ve hesap bakiyenizi bu menüde görebilirsiniz.

5. **Ayarlar**: Buradan şirketinizi veya hesabınızı silebilirsiniz.

## User Rolü

**User** rolündeki kullanıcılar yalnızca **Home** (NFC) menüsüne erişebilirler ve NFC ödemelerini bu menü üzerinden gerçekleştirebilirler.

## Backend

Uygulamanın backend kısmı **Node.js** ile yazılmıştır ve AWS altyapısı üzerinde çalışmaktadır. (Lambda, API Gateway, Cognito, DynamoDB). Detaylar için https://github.com/omerbsagir/nodejs_for_epos

## Nasıl Kurulur?

1. **Flutter** SDK'sını yükleyin.
2. Projeyi GitHub üzerinden klonlayın.
   ```bash
   git clone https://github.com/username/flutter-pos-app.git
   ```
3. Gerekli bağımlılıkları yükleyin:
   ```bash
   flutter pub get
   ```
4. Uygulamayı çalıştırın:
   ```bash
   flutter run
   ```

## Katkıda Bulunma

Katkıda bulunmak isterseniz, lütfen bir pull request oluşturun veya bir issue açın.

---

# Virtual POS Application

## Overview

NOTE: The application currently only checks if the content of NFC tags is null or not. The relevant data is not being sent to any bank or other external endpoint; this process is currently mocked. You can extend this functionality to include actual data processing as per your needs!!

This application is a virtual POS system developed using **Flutter**. It offers two authorization levels for company owners and employees: **Admin** and **User**. Authentication and Authorization processes are managed via **JWT** tokens. Accounts with the **User** role can only be registered by users with the **Admin** role through the **My Company** menu of the app.

## Admin Role

The **Admin** role users have access to five main menus:

1. **Home**: This menu is used to receive NFC payments. To receive payments, you need to register a company and ensure that it is active.

2. **My Company**: Here, you can create a company, view details of your existing company, and register employee accounts.

3. **Activation**: After registering your company, you need to create an activation to enable payments. If there is an existing activation request, the activation status will be displayed in this menu. To set the activation status, you need to change the relevant variable in the corresponding table in the database (DynamoDB) to either true or false.

4. **My Wallet**: In this menu, you can view details of payments made to the IBAN you specified during company registration and check your account balance.

5. **Settings**: Here, you can delete your company or account.

## User Role

Users with the **User** role have access only to the **Home** (NFC) menu, where they can perform NFC payments.

## Backend

The backend of the application is written in **Node.js** and runs on AWS infrastructure (Lambda, API Gateway, Cognito, DynamoDB). For details check https://github.com/omerbsagir/nodejs_for_epos

## How to Install?

1. Install **Flutter** SDK.
2. Clone the project from GitHub.
   ```bash
   git clone https://github.com/username/flutter-pos-app.git
   ```
3. Install the necessary dependencies:
   ```bash
   flutter pub get
   ```
4. Run the application:
   ```bash
   flutter run
   ```

## Contributing

If you would like to contribute, please create a pull request or open an issue.

---
