using { demouserzz as my } from '../db/schema.cds';

@path: '/service/demouserzzapp'
@requires: 'authenticated-user'
service demouserzzSrv {
  @odata.draft.enabled
  entity Incidents as projection on my.Incidents;
  @odata.draft.enabled
  entity Customers as projection on my.Customers;

  @readonly 
  @(requires: 'support')
  entity Qrybasedapi as
  select key A.ID, 
        A.title,A.status, B.name
  from my.Incidents as A inner join my.Customers as B
  on A.customer_ID = B.ID;

  annotate my.Incidents {
  customer @changelog: [customer.name];
  title    @changelog;
  status   @changelog;
  }

  annotate my.Customers with @PersonalData : {
    DataSubjectRole : 'Customer',
    EntitySemantics : 'DataSubject'
  } {
    ID           @PersonalData.FieldSemantics: 'DataSubjectID';
    firstName    @PersonalData.IsPotentiallyPersonal;
    lastName     @PersonalData.IsPotentiallyPersonal;
    email        @PersonalData.IsPotentiallyPersonal;
    creditCardNumber @PersonalData.IsPotentiallySensitive;
  };

  //s4hana api hub
  @readonly
  entity Suppliers as projection on my.Suppliers;    

  //action
  @requires: 'authenticated-user'
  action saveIncidents ( title: String, urgency: String, status: String, customer_ID: UUID ) returns { ID: UUID; title: String; status: String };  
}