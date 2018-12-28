/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestWarehouseUtils {

    // test the class constructor
    @isTest static void testClassConstructor() {
        Test.startTest();
        WarehouseUtils utils = new WarehouseUtils(null);
        Test.stopTest();

        System.assert(utils != null);
    }

    @isTest static void testFindWarehousesDefaultLocation() {
        String myLat = null;
        String myLon = null;

        Warehouse__c closestWarehouse = createClosestTestWarehouse();
        Warehouse__c closeWarehouse = createCloseTestWarehouse();
        Warehouse__c tooFarWarehouse = createTooFarTestWarehouse();

        Test.startTest();
        List<Warehouse__c> nearbyWarehouses = WarehouseUtils.findNearbyWarehouses(myLat, myLon);
        Test.stopTest();

        System.assert(nearbyWarehouses.size() == 2);

        System.assert(nearbyWarehouses[0].Name == closestWarehouse.Name);
        System.assert(nearbyWarehouses[1].Name == closeWarehouse.Name);

        if (0 < nearbyWarehouses.size()) {
            for (Warehouse__c wh : nearbyWarehouses) {
                System.assert(wh.Name != tooFarWarehouse.Name);
            }
        }
    }

    @isTest static void testFindWarehouseWithinTwentyMiles() {
        // Salesforce HQ
        String myLat = '37.793731';
        String myLon = '-122.395002';

        Warehouse__c closestWarehouse = createClosestTestWarehouse();
        Warehouse__c closeWarehouse = createCloseTestWarehouse();
        Warehouse__c tooFarWarehouse = createTooFarTestWarehouse();

        Test.startTest();
        List<Warehouse__c> nearbyWarehouses = WarehouseUtils.findNearbyWarehouses(myLat, myLon);
        Test.stopTest();

        System.assert(nearbyWarehouses.size() == 2);

        System.assert(nearbyWarehouses[0].Name == closestWarehouse.Name);
        System.assert(nearbyWarehouses[1].Name == closeWarehouse.Name);

        if (0 < nearbyWarehouses.size()) {
            for (Warehouse__c wh : nearbyWarehouses) {
                System.assert(wh.Name != tooFarWarehouse.Name);
            }
        }
    }

    @isTest static void testDontFindWarehouseFurtherThanTwentyMiles() {
        // Eiffel Tower, Paris, France
        String myLat = '48.85837';
        String myLon = '2.294481';

        Warehouse__c closestWarehouse = createClosestTestWarehouse();
        Warehouse__c closeWarehouse = createCloseTestWarehouse();
        Warehouse__c tooFarWarehouse = createTooFarTestWarehouse();

        Test.startTest();
        List<Warehouse__c> nearbyWarehouses = WarehouseUtils.findNearbyWarehouses(myLat, myLon);
        Test.stopTest();

        System.assert(nearbyWarehouses.size() == 0);
    }

    static Warehouse__c createTestWarehouse(String name, Decimal lat, Decimal lon) {
        Warehouse__c w = new Warehouse__c(
            Name = name,
            Location__Latitude__s = lat,
            Location__Longitude__s = lon
        );
        insert w;
        return w;
    }

    static Warehouse__c createClosestTestWarehouse() {
        return createTestWarehouse('Warehouse1', 37.7927731, -122.4010922);
    }

    static Warehouse__c createCloseTestWarehouse() {
        return createTestWarehouse('Warehouse2', 37.783944, -122.401289);
    }

    static Warehouse__c createTooFarTestWarehouse() {
        return createTestWarehouse('Warehouse3', 43.879102, -103.459067);
    }
}