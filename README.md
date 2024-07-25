# avacloud-demo-dart

[**AVA**Cloud](https://www.dangl-it.com/products/avacloud-gaeb-saas/) is a web based Software as a Service (SaaS) offering for [GAEB files](https://www.dangl-it.com/articles/what-is-gaeb/).  
The GAEB standard is a widely used format to exchange tenderings, bills of quantities and contracts both in the construction industry and in regular commerce. **AVA**Cloud uses the [GAEB & AVA .Net Libraries](https://www.dangl-it.com/products/gaeb-ava-net-library/) and makes them available to virtually all programming frameworks via a web service.

This project here contains example code in Dart to read and convert GAEB files. The client code is generated from the [**AVA**Cloud Swagger Specification](https://avacloud-api.dangl-it.com/swagger-internal).

## Build

Execute the following command in the root directory of the project:

    dart pub get

## Run

Execute the following command in the root directory of the project:

    dart run

At the top of the `app.ts` file, the following parameters must be defined by you:

    final clientId = 'InsertYourClientId';
    final clientSecret = 'InsertYourClientSecret';

These are the credentials of your [**Dangl.Identity**](https://identity.dangl-it.com) OAuth2 client that is configured to access **AVA**Cloud.  
If you don't have values for `ClientId` and `ClientSecret` yet, you can [check out the documentation](https://docs.dangl-it.com/Projects/AVACloud/latest/howto/registration/developer_signup.html) for instructions on how to register for **AVA**Cloud and create an OAuth2 client.

This example app does three operations:

1. The local GAEB file is converted to an AVA project and some basic information is extracted and printed to the console
2. The local GAEB file is converted to Excel and saved in the root directory
3. It creates a new GAEB file and saves it to `GAEBXML_EN_Created.x86`. The GAEB file only has a single position in it and is in the GAEB XML format.

---

[License](./LICENSE.md)
