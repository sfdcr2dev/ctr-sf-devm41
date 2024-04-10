public class CTRApiJsonDataHelper 
{
    
    private List<Map<String,Object>> input;
    
    public CTRApiJsonDataHelper() 
    {
        
        input = new List<Map<String,Object>>();
        
    }
    
    public void add(Map<String,Object> data )
    {
        
        this.input.add(data);
        
    }
    
    /*
public Integer size()
{
return this.listData.size();
}*/
    
    public List<Map<String,Object>> getList()
    {
        return this.input;
    }
    
    
}