public class MixedDMLFuture {
    public static void useFutureMethod() {
        // First DML operation
        Account a = new Account(Name='Acme');
        insert a;
        
        // This next operation (insert a user with a role) 
        // can't be mixed with the previous insert unless 
        // it is within a future method. 
        // Call future method to insert a user with a role.
        Util.insertUserWithRole(
            'mruiz@awcomputing.com', 'mruiz', 
            'mruiz@awcomputing.com', 'Ruiz');        
    }
}


//non setup and setup objects =   mixed dml error
//ornekte user ile  accounti ayni class icinde insert ediyos buda mixed dml sebep oluyor
//how can we solve : setup objectleri asyncronis methoda koy for exampl: future, queable (UTIL CLASS )

//setup objects: user,profile,page layout
//non setup obj: contact, account ...

