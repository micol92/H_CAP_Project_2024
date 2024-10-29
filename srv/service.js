const cds = require('@sap/cds');

/**
* Implementation for Risk Management service defined in ./risk-service.cds
*/
//module.exports = cds.service.impl(async function() {

  module.exports = class demouserzzSrv extends cds.ApplicationService {
    
    init() {

      const { Incidents } = cds.entities;
  
    this.before('UPDATE', 'Incidents', async (request) => {
    //    const { Incidents } = cds.entities;

        // Fetch the incident to be updated
        const incident = await SELECT.one.from(Incidents).where({ ID: request.data.ID });
    
        // Check if the incident exists and its status is closed (case insensitive)
        if (incident && incident.status && incident.status.toLowerCase() === 'closed') {
            request.reject(400, 'Cannot modify an incident with status closed.');
        }
    
    });


    this.on('READ', 'Suppliers', async req => {
      const bupa =  await cds.connect.to('API_BUSINESS_PARTNER_0001');
      return bupa.run(req.query);
    });

    this.on('saveIncidents', async req => {

      let { title, urgency, status, customer_ID } = req.data;

      //consistent distributed TX (one commit / one rollback)
      //insert local Books;
      let incident = await INSERT.into( Incidents, {title, urgency, status, customer_ID})
      //let book = await INSERT.into( 'SAP_CAPIRE_BOOKSHOP_BOOKS', {ID, title, stock})

      //insert remote Books;
      //let ql = INSERT.into('Books', {ID, title, stock})
  
      return cds.run(incident);   

    })

    return super.init();
  };    
};
//module.exports = CatalogService
