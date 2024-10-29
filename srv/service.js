const cds = require('@sap/cds');

/**
* Implementation for Risk Management service defined in ./risk-service.cds
*/
//module.exports = cds.service.impl(async function() {

  module.exports = class demouserzzSrv extends cds.ApplicationService {
    
    init() {
    this.before('UPDATE', 'Incidents', async (request) => {
        const { Incidents } = cds.entities;

        // Fetch the incident to be updated
        const incident = await SELECT.one.from(Incidents).where({ ID: request.data.ID });
    
        // Check if the incident exists and its status is closed (case insensitive)
        if (incident && incident.status && incident.status.toLowerCase() === 'closed') {
            request.reject(400, 'Cannot modify an incident with status closed.');
        }
    
    });
    return super.init();
  };    
};
//module.exports = CatalogService
