import 'dart:convert';
import 'dart:io';

import 'package:avacloud_client_dart/api.dart' as avacloud_client;
import 'package:http/http.dart';
import 'package:path/path.dart';

final clientId = 'InsertYourClientId';
final clientSecret = 'InsertYourClientSecret';
final tokenUrl = 'https://identity.dangl-it.com/connect/token';

void main(List<String> arguments) async {
  var setupResult = await setupApiClient();
  if (!setupResult) {
    print('Failed to setup API client');
    return;
  }

  await printGaebContent();
  await convertGaebToExcel();
  await createNewGaebFile();
}

setupApiClient() async {
  var accessToken = await getAccessToken();
  if (accessToken == null) {
    return false;
  }

  avacloud_client.defaultApiClient
      .addDefaultHeader('Authorization', 'Bearer $accessToken');
  return true;
}

getAccessToken() async {
  var tokenResponse = await post(Uri.parse(tokenUrl), body: {
    'grant_type': 'client_credentials',
    'client_id': clientId,
    'client_secret': clientSecret,
    'scope': 'avacloud'
  });

  if (tokenResponse.statusCode != 200) {
    print('Failed to get token: ${tokenResponse.body}');
    return;
  }

  var tokenResponseJson = json.decode(tokenResponse.body);
  var accessToken = tokenResponseJson['access_token'];
  return accessToken;
}

getPositions(List<avacloud_client.IElementDto> elements) {
  var positions = [];
  for (var element in elements) {
    if (element is avacloud_client.PositionDto) {
      positions.add(element);
    } else if (element is avacloud_client.ServiceSpecificationGroupDto) {
      positions.addAll(getPositions((element).elements));
    }
  }

  return positions;
}

printGaebContent() async {
  print('Converting GAEB to AVA');
  final client = avacloud_client.GaebConversionApi();
  final file = File('GAEBXML_EN.X86');
  final fileStream = ByteStream(file.openRead());
  final fileLength = await file.length();
  final multipartFile = MultipartFile(
    'gaebFile',
    fileStream,
    fileLength,
    filename: basename(file.path), // File name
  );

  try {
    final project = await client.gaebConversionConvertToAva(
      removePlainTextLongTexts: true,
      removeHtmlLongTexts: true,
      gaebFile: multipartFile,
    );

    print(project?.projectInformation?.name);

    if (project != null) {
      for (var position
          in getPositions(project.serviceSpecifications[0].elements)) {
        print(
            '${position.itemNumber.stringRepresentation} - ${position.shortText}');
      }
    }
  } catch (ex) {
    print(ex.toString());
  }
}

convertGaebToExcel() async {
  print('Converting GAEB to Excel');
  final client = avacloud_client.GaebConversionApi();
  final file = File('GAEBXML_EN.X86');
  final fileStream = ByteStream(file.openRead());
  final fileLength = await file.length();
  final multipartFile = MultipartFile(
    'gaebFile',
    fileStream,
    fileLength,
    filename: basename(file.path), // File name
  );

  try {
    final excelResponse =
        await client.gaebConversionConvertToExcel(gaebFile: multipartFile);

    excelResponse?.finalize().pipe(File('GAEBXML_EN.xlsx').openWrite());
  } catch (ex) {
    print(ex.toString());
  }
}

createNewGaebFile() async {
  print('Creating new GAEB file');
  final client = avacloud_client.AvaConversionApi();

  final project = avacloud_client.ProjectDto.fromJson(json.decode("""{
  "id": "859c1426-bb72-44c5-9fa3-bc424cd1249f",
  "priceAccuracy": 3,
  "forceStrictTotals": true,
  "priceRoundingMode": "Normal",
  "projectInformation": {
    "priceComponents": [],
    "priceComponentTypes": {},
    "bidderCommentAllowed": false,
    "sideOffersAllowed": false,
    "awardType": "Unspecified",
    "specialAwardKind": "Unspecified",
    "requesters": [],
    "notificationSites": []
  },
  "serviceSpecifications": [
    {
      "id": "a8d85d01-623c-4a97-bdc5-688c4e9653c5",
      "projectHourlyWage": 0,
      "projectTaxRate": 0,
      "projectPriceComponents": [],
      "elements": [
        {
          "unitPrice": 80,
          "quantity": 10,
          "isComplementingPosition": false,
          "unitTag": "m²",
          "labourComponents": {
            "price": 0,
            "hourlyWage": 0,
            "values": [],
            "useOwnHourlyWage": false,
            "totalTime": 0,
            "projectCatalogues": []
          },
          "priceComponents": [
            {
              "price": 80,
              "label": "",
              "values": [
                {
                  "formula": "80",
                  "result": 80,
                  "valid": true,
                  "errorPositionInLine": -1
                }
              ],
              "projectCatalogues": []
            }
          ],
          "quantityComponents": [
            {
              "formula": "10",
              "result": 10,
              "valid": true,
              "errorPositionInLine": -1
            }
          ],
          "subDescriptions": [],
          "comissionStatus": "Undefined",
          "complementedBy": [],
          "complemented": false,
          "amountToBeEnteredByBidder": false,
          "priceCompositionRequired": false,
          "useDifferentTaxRate": false,
          "taxRate": 0,
          "itemNumber": {
            "id": "4e91df0c-3799-4fe0-af3f-e2410ed68cf3",
            "stringRepresentation": "",
            "isSchemaCompliant": true,
            "identifiers": [],
            "isLot": false,
            "hierarchyLevel": 0,
            "isAttachedToPosition": true
          },
          "deductionFactor": 0,
          "totalPrice": 800,
          "totalPriceGross": 800,
          "totalPriceGrossDeducted": 800,
          "deductedPrice": 800,
          "positionType": "Regular",
          "priceType": "WithTotal",
          "serviceType": "Regular",
          "shortText": "Concrete Wall",
          "additionType": "None",
          "elementType": "PositionDto",
          "quantityAssignments": [],
          "isLumpSum": false,
          "complementedByQuantities": [],
          "notOffered": false,
          "hierarchyLevel": 0,
          "hasBidderCommentInHtmlLongText": false,
          "gaebComplementingType": "Undefined",
          "ignoreProjectCataloguePropagation": false,
          "id": "205498be-55bc-4732-ac49-5ec739fd4304",
          "projectCatalogues": [],
          "catalogueReferences": [],
          "elementTypeDiscriminator": "PositionDto"
        }
      ],
      "containsDuplicateItemNumbers": false,
      "containsDuplicateElementIds": false,
      "ignoreDuplicateItemNumbers": false,
      "ignoreProjectCataloguePropagation": false,
      "ignoreDuplicateElementIds": false,
      "totalPriceGrossByTaxRate": [
        {
          "taxRate": 0,
          "deductionFactor": 0,
          "totalNet": 800,
          "totalDeducted": 800,
          "totalTax": 0,
          "totalGross": 800,
          "totalGrossDeducted": 800,
          "totalTaxDeducted": 0
        }
      ],
      "ignoreChildPriceUpdates": false,
      "deductedPrice": 800,
      "deductionFactor": 0,
      "totalPrice": 800,
      "totalPriceGross": 800,
      "totalPriceGrossDeducted": 800,
      "priceType": "WithTotal",
      "projectInformation": {
        "priceComponents": [],
        "priceComponentTypes": {},
        "bidderCommentAllowed": false,
        "sideOffersAllowed": false,
        "awardType": "Unspecified",
        "specialAwardKind": "Unspecified",
        "requesters": [],
        "notificationSites": []
      },
      "exchangePhase": "Grant",
      "origin": "Self",
      "creationDate": "2024-07-25T10:17:57.2259133Z",
      "warrantyBondPercentage": 0,
      "executionGuaranteePercentage": 0,
      "priceInformation": {
        "id": "9df90930-5bb7-4c32-bb29-d8647f6c59a0",
        "hourlyWage": 0,
        "deductionFactor": 0,
        "flatSum": 0,
        "taxRate": 0,
        "hasUnsetTaxRate": false,
        "tradeDiscounts": []
      },
      "projectCatalogues": [],
      "catalogueReferences": []
    }
  ]
}"""));

  try {
    final gaebResponse = await client.avaConversionConvertToGaeb(project!);

    gaebResponse?.finalize().pipe(File('GAEBXML_EN_Created.x86').openWrite());
  } catch (ex) {
    print(ex.toString());
  }
}
