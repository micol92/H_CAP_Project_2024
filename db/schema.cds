namespace demouserzz;
using { cuid,managed } from '@sap/cds/common';
using { Attachments } from '@cap-js/attachments';

@assert.unique: { title: [title] }
entity Incidents : cuid,managed {
  title: String(100);
  urgency: String(20);
  status: String(20);
  customerEmail: String(100);
  attachments: Composition of many Attachments;
  conversations: Composition of many Conversations on conversations.incident = $self;
  customer_ID : UUID;
  customer: Association to Customers on customer.ID = customer_ID;
}

entity Conversations : cuid {
  timestamp: Timestamp;
  author: String(100);
  message: String(500);
  incident: Association to Incidents;
}

@assert.unique: { email: [email] }
entity Customers : cuid {
  firstName: String(50);
  lastName: String(50);
  name : String(100) = (firstName || ' ' || lastName);
  phoneNumber: String(20);
  email: String(100);
  creditCardNumber: String(20);
  incidents: Association to many Incidents on incidents.customer = $self;
}

using {  API_BUSINESS_PARTNER_0001 as bupa } from '../srv/external/API_BUSINESS_PARTNER_0001';

    entity Suppliers as projection on bupa.A_BusinessPartner {
        key BusinessPartner as ID,
        BusinessPartnerFullName as fullName,
        BusinessPartnerIsBlocked as isBlocked,
}