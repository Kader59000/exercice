import { LightningElement, wire, api } from 'lwc';
import getWSLogsByApplicationId from '@salesforce/apex/WSLogController.getWSLogsByApplicationId';

export default class WsLogPriorityCount extends LightningElement {
    priorityCounts;
    error;

    @api recordId;
    lowPriority = 0;
    highPriority = 0;
    criticalPriority = 0;

    @wire(getWSLogsByApplicationId, {applicationId: '$recordId'})
    getPriorities({ error, data }) {
        if (data) {
            console.log('WS Logs Data:', data);
            this.lowPriority = 0;
            this.highPriority = 0;
            this.criticalPriority = 0;
            data.forEach(log => {
                switch(log.Priority__c) {
                    case 'Lower':
                        this.lowPriority++;
                        break;
                    case 'High':
                        this.highPriority++;
                        break;
                    case 'Critical':
                        this.criticalPriority++;
                        break;
                    default:
                        break;
                }
            })
        } else if (error) {
            this.error = error.body.message;
        }
    }
}