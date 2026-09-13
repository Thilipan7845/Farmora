# Farmora API Contract v1

## Overview

This document defines the communication contract between:

- Farmora Backend (FastAPI)
- Farmora Frontend (Flutter)

The purpose is to ensure both teams use the same:

- API endpoints
- Request formats
- Response formats
- Authentication method
- Error handling

---

# Backend Information

## Base URL

Development:
http://127.0.0.1:8000

Production:

(To be updated)

---

# Authentication

Farmora uses Supabase Authentication.

All protected APIs require the Supabase access token.

## Request Header

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
---

# 1. Authentication API

## Get Current User

Returns the currently authenticated user's profile information.

### Endpoint

```http
GET /api/auth/me

### Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>

---

## Success Response

Status Code:

```http
200 OK

```

Response:

```json
{
  "user_id": "user_uuid",
  "full_name": "Farmer Name",
  "phone": "9876543210",
  "role": "farmer"
}
```

---

## Response Fields

| Field | Type | Description |
|---|---|---|
| user_id | string | Supabase authenticated user ID |
| full_name | string | User full name |
| phone | string | Registered phone number |
| role | string | User role (farmer / buyer / fpo) |

---

## Error Responses

### Invalid or Expired Token

Status Code:

```http
401 Unauthorized
```

Response:

```json
{
  "detail": "Invalid or expired authentication token"
}
```

---

### User Profile Not Found

Status Code:

```http
404 Not Found
```

Response:

```json
{
  "detail": "User profile not found"
}
```

---

# 2. Farmer API

Farmer APIs handle farmer profile creation, retrieval, and updates.

All Farmer APIs require authentication.

---

# 2.1 Create Farmer Profile

Creates a farmer profile linked with the authenticated user.

## Endpoint

```http
POST /api/farmers/profile
```

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

## Request Body

```json
{
  "farm_name": "Green Farm",
  "location": "Salem",
  "district": "Salem",
  "state": "Tamil Nadu"
}
```

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "message": "Farmer profile created successfully",
  "farmer": {}
}
```

---

# 2.2 Get Farmer Profile

Returns the logged-in farmer profile.

## Endpoint

```http
GET /api/farmers/profile
```

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "id": "farmer_uuid",
  "farm_name": "Green Farm",
  "location": "Salem",
  "district": "Salem",
  "state": "Tamil Nadu"
}
```

---

# 2.3 Update Farmer Profile

Updates farmer information.

## Endpoint

```http
PUT /api/farmers/profile
```

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

## Request Body

```json
{
  "farm_name": "Updated Farm Name",
  "location": "Coimbatore"
}
```

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "message": "Farmer profile updated successfully",
  "farmer": {}
}
```

---

## Farmer API Error Responses

### Farmer Profile Not Found

Status Code:

```http
404 Not Found
```

Response:

```json
{
  "detail": "Farmer profile not found"
}
```

---

# 3. Crop Lot API

Crop Lot APIs allow farmers to create, view, update, and delete crop listings.

All Crop Lot APIs require authentication.

---

# 3.1 Create Crop Lot

Creates a new crop lot for the authenticated farmer.

## Endpoint

```http
POST /api/crop-lots
```

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

## Request Body

```json
{
  "crop_name": "Cotton",
  "variety": "BT Cotton",
  "quantity": 500,
  "quality_grade": "A",
  "expected_price": 8500,
  "harvest_date": "2026-09-15",
  "latitude": 11.6643,
  "longitude": 78.1460,
  "crop_image_url": "https://example.com/cotton.jpg"
}
```

---

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "message": "Crop lot created successfully",
  "crop_lot": {
    "id": "crop_lot_uuid",
    "farmer_id": "farmer_uuid",
    "crop_name": "Cotton",
    "quantity": 500,
    "availability": "available"
  }
}
```

---

# 3.2 Get My Crop Lots

Returns all crop lots created by the logged-in farmer.

## Endpoint

```http
GET /api/crop-lots
```

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "farmer_id": "farmer_uuid",
  "crop_lots": [
    {
      "id": "crop_lot_uuid",
      "crop_name": "Cotton",
      "quantity": 500,
      "quality_grade": "A",
      "availability": "available"
    }
  ]
}
```

---

# 3.3 Get Single Crop Lot

Returns details of a specific crop lot.

## Endpoint

```http
GET /api/crop-lots/{lot_id}
```

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "id": "crop_lot_uuid",
  "crop_name": "Cotton",
  "variety": "BT Cotton",
  "quantity": 500,
  "quality_grade": "A"
}
```

---

# 3.4 Update Crop Lot

Updates existing crop lot information.

## Endpoint

```http
PUT /api/crop-lots/{lot_id}
```

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

## Request Body

```json
{
  "expected_price": 9000,
  "quality_grade": "A+"
}
```

---

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "message": "Crop lot updated successfully",
  "crop_lot": {}
}
```

---

# 3.5 Delete Crop Lot

Deletes a crop lot created by the farmer.

## Endpoint

```http
DELETE /api/crop-lots/{lot_id}
```

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "message": "Crop lot deleted successfully"
}
```

---

## Crop Lot API Error Responses

### Crop Lot Not Found

Status Code:

```http
404 Not Found
```

Response:

```json
{
  "detail": "Crop lot not found"
}
```

### Farmer Profile Not Found

Status Code:

```http
404 Not Found
```

Response:

```json
{
  "detail": "Farmer profile not found"
}
```

---
# 4. Intelligence API

The Intelligence API provides AI-based market prediction and selling recommendations for farmers.

The API internally connects:

```
Market Price History
        |
        ↓
Feature Builder
        |
        ↓
ML Price Prediction Model
        |
        ↓
Decision Engine
        |
        ↓
Profit Engine
        |
        ↓
Farmer Explanation
```

All Intelligence APIs require authentication.

---

# 4.1 Get Market Decision Prediction

Generates price prediction and recommendation for a crop.

## Endpoint

```http
POST /api/intelligence/decision
```

---

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## Request Body

```json
{
  "crop": "cotton",
  "market": "Nagpur APMC",
  "variety": "BT Cotton",
  "grade": "A",

  "storage_available": true,
  "storage_cost": 500,

  "demand_level": "medium",

  "quantity": 500,

  "transport_cost": 3000,
  "storage_expense": 1000
}
```

---

# Request Fields

| Field | Type | Description |
|---|---|---|
| crop | string | Crop name |
| market | string | Market name |
| variety | string | Crop variety |
| grade | string | Quality grade |
| storage_available | boolean | Whether farmer has storage |
| storage_cost | float | Storage cost consideration |
| demand_level | string | Current demand level |
| quantity | float | Available crop quantity |
| transport_cost | float | Transportation cost |
| storage_expense | float | Additional storage expense |

---

# Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "current_price": 8800,

  "predicted_price": 8221.8,

  "expected_change_percent": -6.57,

  "prediction_horizon_days": 14,

  "confidence_score": 74.47,

  "expected_price_range": {
    "lower": 7855.93,
    "upper": 8587.68
  },

  "trend": "FALLING",

  "recommendation": "SELL NOW",

  "reasons": [
    "Expected price decrease"
  ],

  "profit_analysis": {
    "current_net_realization": 4400000,
    "future_net_realization": 4098900.62,
    "profit_difference": -301099.37,
    "better_choice": "SELL NOW"
  },

  "crop_profile": {
    "shelf_life_days": 270,
    "storage_risk": "LOW",
    "cold_storage_required": false
  },

  "farmer_explanation": {

    "farmer_message":
    "Sell your cotton now to avoid possible price loss.",

    "action": "SELL NOW",

    "confidence": "HIGH"
  }
}
```

---

# Intelligence Response Fields

| Field | Type | Description |
|---|---|---|
| current_price | float | Current market price |
| predicted_price | float | AI predicted future price |
| expected_change_percent | float | Expected price change |
| prediction_horizon_days | integer | Prediction period |
| confidence_score | float | Model confidence |
| trend | string | RISING/FALLING/STABLE |
| recommendation | string | SELL NOW/HOLD |
| reasons | array | Decision reasons |
| profit_analysis | object | Profit comparison |
| farmer_explanation | object | Farmer friendly explanation |

---

# Possible Errors

## Market History Not Available

Status:

```http
400 Bad Request
```

Response:

```json
{
  "detail": "No market price history found"
}
```

---

## Invalid Authentication

Status:

```http
401 Unauthorized
```

Response:

```json
{
  "detail": "Invalid or expired authentication token"
}
```

---

## Prediction Failure

Status:

```http
500 Internal Server Error
```

Response:

```json
{
  "detail": "Unable to generate market prediction"
}
```

---

# 5. Buyer Matching API

The Buyer Matching API finds suitable buyers for a farmer's crop lot based on:

- Crop type
- Required quantity
- Quality grade
- Buyer requirements
- Location preference

All Buyer Matching APIs require authentication.

---

# 5.1 Find Matching Buyers

Returns a list of buyers who match a farmer's crop lot.

## Endpoint

```http
POST /api/buyer-matching
```

---

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## Request Body

```json
{
  "crop_lot_id": "crop_lot_uuid"
}
```

---

# Request Fields

| Field | Type | Description |
|---|---|---|
| crop_lot_id | string | ID of farmer crop lot |

---

# Success Response

Status Code:

```http
200 OK
```

Response:

```json
[
  {
    "buyer_id": "buyer_uuid",
    "company_name": "ABC Agro Traders",
    "business_type": "Wholesale",

    "crop_name": "Cotton",

    "required_quantity": 500,

    "available_quantity": 1000,

    "quality_grade": "A",

    "preferred_location": "Salem",

    "match_score": 92
  }
]
```

---

# Response Fields

| Field | Type | Description |
|---|---|---|
| buyer_id | string | Buyer unique ID |
| company_name | string | Buyer company name |
| business_type | string | Buyer business category |
| crop_name | string | Required crop |
| required_quantity | float | Quantity required by buyer |
| available_quantity | float | Buyer's available capacity |
| quality_grade | string | Required quality grade |
| preferred_location | string | Preferred purchase location |
| match_score | float | Matching percentage score |

---

# Matching Score Explanation

The match score represents compatibility between farmer crop lot and buyer requirement.

Example:

```
92% Match

Reasons:
✓ Crop matched
✓ Quantity available
✓ Quality matched
✓ Location suitable
```

---

# Possible Errors

## Crop Lot Not Found

Status:

```http
404 Not Found
```

Response:

```json
{
  "detail": "Crop lot not found"
}
```

---

## Unauthorized Access

Status:

```http
401 Unauthorized
```

Response:

```json
{
  "detail": "Invalid or expired authentication token"
}
```

---

## No Matching Buyers Found

Status:

```http
404 Not Found
```

Response:

```json
{
  "detail": "No matching buyers found"
}
```

---

# 6. Buyer API

Buyer APIs manage buyer profile information and crop purchasing requirements.

All Buyer APIs require authentication.

---

# 6.1 Create Buyer Profile

Creates a buyer profile linked with the authenticated user.

## Endpoint

```http
POST /api/buyers/profile
```

---

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## Request Body

```json
{
  "company_name": "ABC Agro Traders",
  "business_type": "Wholesale",
  "location": "Chennai",
  "district": "Chennai",
  "state": "Tamil Nadu"
}
```

---

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "message": "Buyer profile created successfully",
  "buyer": {}
}
```

---

# 6.2 Get Buyer Profile

Returns the authenticated buyer profile.

## Endpoint

```http
GET /api/buyers/profile
```

---

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "id": "buyer_uuid",
  "company_name": "ABC Agro Traders",
  "business_type": "Wholesale",
  "location": "Chennai"
}
```

---

# 6.3 Update Buyer Profile

Updates buyer information.

## Endpoint

```http
PUT /api/buyers/profile
```

---

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## Request Body

```json
{
  "company_name": "Updated Agro Traders",
  "location": "Coimbatore"
}
```

---

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "message": "Buyer profile updated successfully",
  "buyer": {}
}
```

---

# 6.4 Create Buyer Requirement

Creates a crop requirement from a buyer.

## Endpoint

```http
POST /api/buyers/requirements
```

---

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## Request Body

```json
{
  "crop_name": "Cotton",
  "quantity": 1000,
  "quality_grade": "A",
  "min_price": 8000,
  "max_price": 9000,
  "preferred_location": "Salem",
  "delivery_required": true,
  "delivery_location": "Chennai"
}
```

---

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "message": "Buyer requirement created successfully",
  "requirement": {}
}
```

---

# 6.5 Get Buyer Requirements

Returns requirements created by the authenticated buyer.

## Endpoint

```http
GET /api/buyers/requirements
```

---

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "buyer_id": "buyer_uuid",
  "requirements": [
    {
      "crop_name": "Cotton",
      "quantity": 1000,
      "quality_grade": "A",
      "status": "active"
    }
  ]
}
```

---

# Buyer API Error Responses

## Buyer Profile Not Found

Status Code:

```http
404 Not Found
```

Response:

```json
{
  "detail": "Buyer profile not found"
}
```

---

## Invalid Authentication

Status Code:

```http
401 Unauthorized
```

Response:

```json
{
  "detail": "Invalid or expired authentication token"
}
```

---

# 7. Offers API

Offer APIs manage purchase offers between buyers and farmers.

A buyer can create an offer for a farmer's crop lot.

All Offer APIs require authentication.

---

# 7.1 Create Offer

Creates a new purchase offer for a crop lot.

## Endpoint

```http
POST /api/offers
```

---

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## Request Body

```json
{
  "crop_lot_id": "crop_lot_uuid",
  "quantity": 500,
  "offered_price": 8500,
  "message": "Interested in purchasing this crop"
}
```

---

## Request Fields

| Field | Type | Description |
|---|---|---|
| crop_lot_id | string | Crop lot ID |
| quantity | float | Required quantity |
| offered_price | float | Price offered per unit |
| message | string | Optional buyer message |

---

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "message": "Offer created successfully",
  "offer": {
    "id": "offer_uuid",
    "crop_lot_id": "crop_lot_uuid",
    "quantity": 500,
    "offered_price": 8500,
    "status": "pending"
  }
}
```

---

# 7.2 Get Offers

Returns offers related to the authenticated user.

## Endpoint

```http
GET /api/offers
```

---

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "offers": [
    {
      "id": "offer_uuid",
      "crop_lot_id": "crop_lot_uuid",
      "quantity": 500,
      "offered_price": 8500,
      "status": "pending"
    }
  ]
}
```

---

# 7.3 Update Offer Status

Updates offer acceptance or rejection status.

## Endpoint

```http
PUT /api/offers/{offer_id}/status
```

---

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## Request Body

```json
{
  "status": "accepted"
}
```

Allowed statuses:

```
pending
accepted
rejected
cancelled
```

---

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "message": "Offer status updated successfully",
  "offer": {}
}
```

---

# 7.4 Negotiation

Allows buyer and farmer to negotiate price and quantity.

## Endpoint

```http
POST /api/offers/negotiation
```

---

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## Request Body

```json
{
  "offer_id": "offer_uuid",
  "sender_type": "buyer",
  "offered_price": 8700,
  "quantity": 500,
  "message": "Can we finalize at this price?"
}
```

---

## Request Fields

| Field | Type | Description |
|---|---|---|
| offer_id | string | Related offer ID |
| sender_type | string | buyer / farmer |
| offered_price | float | Negotiated price |
| quantity | float | Negotiated quantity |
| message | string | Negotiation message |

---

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "message": "Negotiation created successfully",
  "negotiation": {}
}
```

---

# Offer API Error Responses

## Crop Lot Not Found

Status Code:

```http
404 Not Found
```

Response:

```json
{
  "detail": "Crop lot not found"
}
```

---

## Unauthorized Access

Status Code:

```http
403 Forbidden
```

Response:

```json
{
  "detail": "You are not allowed to perform this action"
}
```

---

## Invalid Authentication

Status Code:

```http
401 Unauthorized
```

Response:

```json
{
  "detail": "Invalid or expired authentication token"
}
```

---

# 8. Orders API

Order APIs manage confirmed transactions between buyers and farmers after an offer is accepted.

All Order APIs require authentication.

---

# 8.1 Create Order

Creates an order from an accepted offer.

## Endpoint

```http
POST /api/orders
```

---

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## Request Body

```json
{
  "offer_id": "offer_uuid",
  "quantity": 500,
  "agreed_price": 8500
}
```

---

## Request Fields

| Field | Type | Description |
|---|---|---|
| offer_id | string | Accepted offer ID |
| quantity | float | Ordered quantity |
| agreed_price | float | Final agreed price per unit |

---

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "message": "Order created successfully",
  "order": {
    "id": "order_uuid",
    "offer_id": "offer_uuid",
    "farmer_id": "farmer_uuid",
    "buyer_id": "buyer_uuid",
    "crop_lot_id": "crop_lot_uuid",
    "quantity": 500,
    "agreed_price": 8500,
    "total_amount": 4250000,
    "status": "pending"
  }
}
```

---

# 8.2 Get My Orders

Returns orders belonging to the authenticated buyer.

## Endpoint

```http
GET /api/orders
```

---

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "buyer_id": "buyer_uuid",
  "orders": [
    {
      "id": "order_uuid",
      "crop_lot_id": "crop_lot_uuid",
      "quantity": 500,
      "agreed_price": 8500,
      "status": "pending"
    }
  ]
}
```

---

# 8.3 Get Single Order

Returns details of a specific order.

## Endpoint

```http
GET /api/orders/{order_id}
```

---

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "id": "order_uuid",
  "farmer_id": "farmer_uuid",
  "buyer_id": "buyer_uuid",
  "crop_lot_id": "crop_lot_uuid",
  "quantity": 500,
  "agreed_price": 8500,
  "total_amount": 4250000,
  "status": "pending"
}
```

---

# 8.4 Update Order Status

Updates the current order status.

## Endpoint

```http
PUT /api/orders/{order_id}/status
```

---

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## Request Body

```json
{
  "status": "confirmed"
}
```

---

## Allowed Status Values

```
pending
confirmed
processing
shipped
delivered
completed
cancelled
```

---

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "message": "Order status updated successfully",
  "order": {}
}
```

---

# Order Status Flow

```text
pending
   ↓
confirmed
   ↓
processing
   ↓
delivered
   ↓
completed
```

Cancellation:

```text
pending/confirmed
        ↓
    cancelled
```

---

# Order API Error Responses

## Offer Not Found

Status Code:

```http
404 Not Found
```

Response:

```json
{
  "detail": "Offer not found"
}
```

---

## Offer Not Accepted

Status Code:

```http
400 Bad Request
```

Response:

```json
{
  "detail": "Order can only be created from an accepted offer"
}
```

---

## Unauthorized Access

Status Code:

```http
403 Forbidden
```

Response:

```json
{
  "detail": "You are not allowed to perform this action"
}
```

---

## Invalid Authentication

Status Code:

```http
401 Unauthorized
```

Response:

```json
{
  "detail": "Invalid or expired authentication token"
}
```

---

# 9. Logistics API

Logistics APIs manage transportation details and delivery tracking for confirmed orders.

All Logistics APIs require authentication.

---

# 9.1 Create Logistics

Creates a logistics record for an order.

Only the buyer who owns the order can create logistics.

## Endpoint

```http
POST /api/logistics
```

---

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## Request Body

```json
{
  "order_id": "order_uuid",

  "pickup_location": "Salem Farm",
  "delivery_location": "Chennai Warehouse",

  "pickup_latitude": 11.6643,
  "pickup_longitude": 78.1460,

  "delivery_latitude": 13.0827,
  "delivery_longitude": 80.2707,

  "distance_km": 340,

  "transport_type": "Truck",

  "transport_cost": 5000,

  "estimated_delivery_date": "2026-09-20"
}
```

---

## Request Fields

| Field | Type | Description |
|---|---|---|
| order_id | string | Related order ID |
| pickup_location | string | Pickup location |
| delivery_location | string | Delivery location |
| pickup_latitude | float | Pickup latitude |
| pickup_longitude | float | Pickup longitude |
| delivery_latitude | float | Delivery latitude |
| delivery_longitude | float | Delivery longitude |
| distance_km | float | Delivery distance |
| transport_type | string | Vehicle type |
| transport_cost | float | Transportation cost |
| estimated_delivery_date | date | Expected delivery date |

---

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "message": "Logistics created successfully",
  "logistics": {
    "id": "logistics_uuid",
    "order_id": "order_uuid",
    "status": "pending"
  }
}
```

---

# 9.2 Get My Logistics

Returns logistics records related to the authenticated buyer's orders.

## Endpoint

```http
GET /api/logistics
```

---

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "logistics": [
    {
      "id": "logistics_uuid",
      "order_id": "order_uuid",
      "pickup_location": "Salem",
      "delivery_location": "Chennai",
      "status": "in_transit"
    }
  ]
}
```

---

# 9.3 Get Single Logistics Record

Returns details of a specific logistics record.

## Endpoint

```http
GET /api/logistics/{logistics_id}
```

---

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "id": "logistics_uuid",
  "order_id": "order_uuid",
  "pickup_location": "Salem",
  "delivery_location": "Chennai",
  "distance_km": 340,
  "transport_type": "Truck",
  "transport_cost": 5000,
  "status": "pending"
}
```

---

# 9.4 Update Logistics Status

Updates delivery progress.

## Endpoint

```http
PUT /api/logistics/{logistics_id}/status
```

---

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## Request Body

```json
{
  "status": "in_transit"
}
```

---

## Allowed Status Values

```
pending
picked_up
in_transit
delivered
cancelled
completed
```

---

# Logistics Status Flow

```text
pending
   ↓
picked_up
   ↓
in_transit
   ↓
delivered
   ↓
completed
```

Cancellation:

```
pending/in_transit
        ↓
    cancelled
```

---

# Order Status Synchronization

When logistics status changes, order status is updated automatically.

Mapping:

| Logistics Status | Order Status |
|---|---|
| pending | pending |
| picked_up | processing |
| in_transit | processing |
| delivered | delivered |
| cancelled | cancelled |
| completed | completed |

---

# Logistics API Error Responses

## Order Not Found

Status Code:

```http
404 Not Found
```

Response:

```json
{
  "detail": "Order not found"
}
```

---

## Unauthorized Access

Status Code:

```http
403 Forbidden
```

Response:

```json
{
  "detail": "You are not allowed to perform this action"
}
```

---

## Invalid Authentication

Status Code:

```http
401 Unauthorized
```

Response:

```json
{
  "detail": "Invalid or expired authentication token"
}
```

---

# 10. Payment API

Payment APIs manage payment records associated with completed orders.

All Payment APIs require authentication.

---

# 10.1 Create Payment

Creates a payment record for an order.

Payment should be created only for valid orders.

## Endpoint

```http
POST /api/payments
```

---

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## Request Body

```json
{
  "order_id": "order_uuid",
  "amount": 4250000,
  "payment_method": "UPI",
  "transaction_reference": "TXN123456"
}
```

---

## Request Fields

| Field | Type | Description |
|---|---|---|
| order_id | string | Related order ID |
| amount | float | Payment amount |
| payment_method | string | Payment mode |
| transaction_reference | string | Payment transaction ID |

---

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "message": "Payment created successfully",
  "payment": {
    "id": "payment_uuid",
    "order_id": "order_uuid",
    "amount": 4250000,
    "payment_method": "UPI",
    "status": "pending"
  }
}
```

---

# 10.2 Get My Payments

Returns payments related to the authenticated user.

## Endpoint

```http
GET /api/payments
```

---

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "payments": [
    {
      "id": "payment_uuid",
      "order_id": "order_uuid",
      "amount": 4250000,
      "payment_method": "UPI",
      "status": "completed"
    }
  ]
}
```

---

# 10.3 Get Single Payment

Returns payment details.

## Endpoint

```http
GET /api/payments/{payment_id}
```

---

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## Success Response

Status Code:

```http
200 OK
```

Response:

```json
{
  "id": "payment_uuid",
  "order_id": "order_uuid",
  "amount": 4250000,
  "payment_method": "UPI",
  "status": "completed",
  "paid_at": "2026-09-20T10:30:00"
}
```

---

# 10.4 Update Payment Status

Updates payment progress.

## Endpoint

```http
PUT /api/payments/{payment_id}/status
```

---

## Headers

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

## Request Body

```json
{
  "status": "completed"
}
```

---

## Allowed Status Values

```
pending
processing
completed
failed
refunded
```

---

# Payment Status Flow

```text
pending
   ↓
processing
   ↓
completed
```

Failure:

```
processing
    ↓
 failed
```

Refund:

```
completed
    ↓
refunded
```

---

# Payment API Error Responses

## Order Not Found

Status Code:

```http
404 Not Found
```

Response:

```json
{
  "detail": "Order not found"
}
```

---

## Invalid Payment Status

Status Code:

```http
400 Bad Request
```

Response:

```json
{
  "detail": "Invalid payment status"
}
```

---

## Unauthorized Access

Status Code:

```http
403 Forbidden
```

Response:

```json
{
  "detail": "You are not allowed to perform this action"
}
```

---

## Invalid Authentication

Status Code:

```http
401 Unauthorized
```

Response:

```json
{
  "detail": "Invalid or expired authentication token"
}
```

---

---

# 11. Flutter ↔ Backend Integration Flow

This section explains how the Flutter application communicates with Farmora Backend.

---

# Authentication Flow

```
Flutter App
     |
     ↓
Supabase Authentication
     |
     ↓
Access Token Generated
     |
     ↓
Store Token Securely
     |
     ↓
Send Token With Every API Request
     |
     ↓
FastAPI Authentication Middleware
     |
     ↓
API Access Granted
```

Every protected API request must include:

```http
Authorization: Bearer <SUPABASE_ACCESS_TOKEN>
```

---

# Farmer Application Flow

## 1. Farmer Registration

Flutter Screen:

```
Farmer Registration
```

API:

```
POST /api/auth
POST /api/farmers/profile
```

Flow:

```
Create Account
      ↓
Create Farmer Profile
      ↓
Dashboard Access
```

---

## 2. Create Crop Listing

Flutter Screen:

```
Add Crop Lot
```

API:

```
POST /api/crop-lots
```

Flow:

```
Farmer enters crop details
      ↓
Backend validates data
      ↓
Crop lot stored in database
      ↓
Available for buyers
```

---

## 3. AI Market Intelligence

Flutter Screen:

```
Market Intelligence
```

API:

```
POST /api/intelligence/decision
```

Flow:

```
Farmer selects crop
      ↓
Backend fetches market history
      ↓
ML prediction generated
      ↓
Decision returned
      ↓
Flutter displays recommendation
```

Example UI:

```
Current Price:
₹8800

Predicted Price:
₹8221

Trend:
FALLING

Recommendation:
SELL NOW

Confidence:
74%
```

---

## 4. Buyer Matching

Flutter Screen:

```
Find Buyers
```

API:

```
POST /api/buyer-matching
```

Flow:

```
Farmer selects crop lot
      ↓
Matching engine searches buyers
      ↓
Match score calculated
      ↓
Buyer cards displayed
```

---

## 5. Offer Management

Flow:

```
Buyer creates offer
        |
        ↓
Farmer receives offer
        |
        ↓
Accept / Reject / Negotiate
```

APIs:

Create Offer:

```
POST /api/offers
```

Update Status:

```
PUT /api/offers/{offer_id}/status
```

---

## 6. Order Processing

Flow:

```
Accepted Offer
       ↓
Create Order
       ↓
Track Order Status
```

API:

```
POST /api/orders
```

---

## 7. Logistics Tracking

Flow:

```
Order Confirmed
       ↓
Create Logistics
       ↓
Delivery Tracking
```

APIs:

Create:

```
POST /api/logistics
```

Update:

```
PUT /api/logistics/{logistics_id}/status
```

---

## 8. Payment Flow

Flow:

```
Order Completed
       ↓
Payment Created
       ↓
Payment Status Updated
```

APIs:

```
POST /api/payments

PUT /api/payments/{payment_id}/status
```

---

# 12. Complete Farmora User Journey

## Farmer Journey

```
Register
   |
   ↓
Create Profile
   |
   ↓
Add Crop Lot
   |
   ↓
View Market Intelligence
   |
   ↓
Find Matching Buyers
   |
   ↓
Receive Offers
   |
   ↓
Negotiate
   |
   ↓
Accept Offer
   |
   ↓
Order Created
   |
   ↓
Track Logistics
   |
   ↓
Receive Payment
```

---

## Buyer Journey

```
Register
   |
   ↓
Create Buyer Profile
   |
   ↓
Add Crop Requirement
   |
   ↓
Find Available Crops
   |
   ↓
Send Offer
   |
   ↓
Negotiate With Farmer
   |
   ↓
Confirm Order
   |
   ↓
Arrange Logistics
   |
   ↓
Complete Payment
```

---

# Backend Integration Rules

## Frontend Team Must:

1. Always send authentication token.

2. Follow request JSON formats.

3. Handle all error responses.

4. Do not directly access Supabase database.

5. Use FastAPI endpoints only.

---

# API Documentation Source

Backend API documentation is available through FastAPI Swagger:

```
http://127.0.0.1:8000/docs
```

OpenAPI specification:

```
http://127.0.0.1:8000/openapi.json
```

---