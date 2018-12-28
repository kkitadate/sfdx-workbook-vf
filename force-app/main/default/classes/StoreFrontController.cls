public class StoreFrontController {
    
    List<DisplayMerchandise> products;
    List<DisplayMerchandise> shoppingCart = new List<DisplayMerchandise>();

    public Pagereference addToCart() {
        for (DisplayMerchandise p : products) {
            if (0 < p.qtyToBuy) {
                shoppingCart.add(p);
            }
        }
        return null; // stay on the same page
    }

    public String getCartContents() {
        if (0 == shoppingCart.size()) {
            return '(empty)';
        }
        String msg = '<ul>\n';
        for (DisplayMerchandise p : shoppingCart) {
            msg += '<li>';
            msg += p.Name + ' (' + p.qtyToBuy + ')';
            msg += '</li>\n';
        }
        msg += '</ul>';
        return msg;
    }

    public List<DisplayMerchandise> getProducts() {
        if (products == null) {
            products = new List<DisplayMerchandise>();
            for (Merchandise__c item : [
                    SELECT Id, Name, Condition__c, Price__c, Quantity__c 
                    FROM Merchandise__c]) {
                products.add(new DisplayMerchandise(item));
            }
        }
        return products;
    }

    public class DisplayMerchandise {
        private Merchandise__c merchandise;
        public DisplayMerchandise(Merchandise__c item) {
            this.merchandise = item;
        }

        public String name {
            get { return merchandise.Name; }
        }
        public String condition {
            get { return merchandise.Condition__c; }
        }
        public Decimal price {
            get { return merchandise.Price__c; }
        }
        public Boolean inStock {
            get { return (0 < merchandise.Quantity__c); }
        }
        public Integer qtyToBuy { get; set; }
    }
}
