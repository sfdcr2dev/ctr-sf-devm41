public class CTRApiJsonDataItemsHelper {
    
    private List<Map<String,String>> listItems;
    
    public CTRApiJsonDataItemsHelper() 
    {
        
        this.listItems = new List<Map<String,String>>();
        
    }
    
    public void add(Map<String,String> item)
    {
        
        this.listItems.add(item);
        
    }
    
    
    public Integer size()
    {
        return this.listItems.size();
    } 
    
    public List<Map<String,String>> getList()
    {
        return this.listItems;
    }
}