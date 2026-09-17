// _______________This Code was generated using GenAI tool : Codify, Please check for accuracy_______________
/**
 * ContactCreationController
 * ---------------------------------------------------------------------------
 * Backend for the myFirstProject Experience Cloud LWC flow.
 * Receives the data collected across firstTile / secondTile / thirdTitle /
 * fourthTile (merged by the myFirstProject parent component into a single
 * object) and creates ONE Contact record.
 *
 * Declared "with sharing" so the Experience Cloud user's sharing rules and
 * record access are respected when the Contact is inserted.
 */
public with sharing class ContactCreationController {

    /**
     * ContactWrapper
     * Inner class whose public fields mirror the fields the LWC gathers.
     * @AuraEnabled on each field lets the JS object sent from the LWC
     * (JSON) be automatically deserialized into this Apex type when passed
     * as a parameter to an @AuraEnabled method - no manual JSON.parse/manual
     * mapping needed on either side.
     */
    public class ContactWrapper {
        @AuraEnabled public String firstName;
        @AuraEnabled public String lastName;
        @AuraEnabled public String email;
        @AuraEnabled public String phone;
        @AuraEnabled public String title;
        @AuraEnabled public String department;
    }

    /**
     * createContact
     * Single @AuraEnabled entry point called imperatively (not @wire) from
     * myFirstProject.js because it performs a write (DML) triggered by the
     * user clicking Submit - imperative calls are the correct pattern for
     * write operations; @wire is reserved for reactive reads.
     *
     * @param contactData ContactWrapper built by the LWC from the merged
     *                    contactData object (FirstName, LastName, Email,
     *                    Phone, Title, Department).
     * @return Id of the newly inserted Contact - returned so the LWC can
     *         confirm success and, if desired, link to the record.
     */
    @AuraEnabled
    public static Id createContact(ContactWrapper contactData) {

        // Guard against a null payload entirely (defensive - should not
        // happen if the LWC always sends an initialized object).
        if (contactData == null) {
            throw new AuraHandledException('No contact data was provided.');
        }

        // LastName is the only field the Contact object enforces as
        // required at the database level - validate it explicitly here so
        // the LWC gets a clear, friendly error instead of a raw DML fault.
        if (String.isBlank(contactData.lastName)) {
            throw new AuraHandledException('Last Name is required to create a Contact.');
        }

        // Build a single Contact sObject from the wrapper. Only one record
        // is built and only one insert is issued below - no SOQL/DML inside
        // any loop, per bulkification guidelines (this flow only ever
        // creates one Contact per Submit click).
        Contact newContact = new Contact(
            FirstName  = contactData.firstName,
            LastName   = contactData.lastName,
            Email      = contactData.email,
            Phone      = contactData.phone,
            Title      = contactData.title,
            Department = contactData.department
        );

        try {
            // Single DML statement - safe outside of any loop.
            insert newContact;
        } catch (DmlException dmlEx) {
            // Surface a clean, user-readable message to the LWC's .catch()
            // instead of leaking the full stack trace to the browser.
            throw new AuraHandledException('Unable to create Contact: ' + dmlEx.getMessage());
        }

        return newContact.Id;
    }
}
// __________________________GenAI: Generated code ends here______________________________