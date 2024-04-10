public class THOR_FTPIntegration implements Database.batchable<SparePartWrapper>
{
    public String fileContent = '';
    public class SparePartWrapper
    {
        String material;
        String plant;
        Double stock;
        String baseUnit;
        String description;
        String mType;
    }
    public THOR_FTPIntegration(String file)
    {
        fileContent = file;
    }

    public Iterable<SparePartWrapper> start(Database.BatchableContext BC)
    {

        List<SparePartWrapper>spList = new List<SparePartWrapper>();
        THOR_Utility_RowIterator r = New THOR_Utility_RowIterator(filecontent,'\n'); //Replace \n with whatever delineates your row


            String line;
            while(r.hasNext())
            {
                line = r.next();
                system.debug('line--'+line);
                String[] linecontent = line.split('\\|');
                system.debug('line-0-'+linecontent[0]);
                system.debug('line-1-'+linecontent[1]);
                system.debug('line-6-'+linecontent[6]);

                Decimal matNoDecimal = Decimal.valueOf(linecontent[0]);
                String convertedMatNo = String.valueOf(matNoDecimal);

                String mat = convertedMatNo;
                String plant = linecontent[1];
                String stock = linecontent[6];
                String baseUnit = linecontent[4];
                String description = linecontent[2];
                String mtype = linecontent[3];
                SparePartWrapper iSp = new SparePartWrapper();
                iSp.material = mat;
                iSp.plant = plant;
                iSp.baseUnit = baseUnit;
                iSp.description = description;
                iSp.mtype = mtype;
                iSp.stock = Double.valueOf(stock);

                spList.add(iSp);

            }

        return spList;
    }

    public void execute(Database.BatchableContext BC, List<SparePartWrapper> sparepartList) {

        try
        {
            if(sparepartList.size() > 0)
            {
                List<Master_Map__c>MasterList = [SELECT Id,Name FROM Master_Map__c WHERE Type__c = 'Plant'];

                Map<String,Spare_Part__c>upsertedSpMap = new Map<String,Spare_Part__c>();
                for(SparePartWrapper wrapper : sparepartList)
                {
                    Spare_Part__c iSp = new Spare_Part__c();
                    iSp.Material_Number__c = wrapper.material;
                    iSp.Name = wrapper.material;
                    iSp.Base_Unit__c = wrapper.baseUnit;
                    iSp.Material_Description__c = wrapper.description;
                    iSp.Type__c = wrapper.mtype;
                    upsertedSpMap.put(wrapper.material,iSp);
                }
                if(upsertedSpMap.values().size() > 0)
                {
                    //system.debug('upsert---1');
                    upsert upsertedSpMap.values() Name;
                }


                Map<String,String>spMap = new Map<String,String>();

                for(Spare_Part__c sp : upsertedSpMap.values())
                {
                    spMap.put(sp.Name,sp.Id);
                }

                List<Spare_Part_Stock__c>stockList = new List<Spare_Part_Stock__c>();

                for(SparePartWrapper wrapper : sparepartList)
                {
                    Spare_Part_Stock__c stock = new Spare_Part_Stock__c();
                    for(Master_Map__c iMaster : MasterList)
                    {
                        if(iMaster.Name == wrapper.plant)
                        {
                            stock.Plant__c = iMaster.Id;
                        }
                    }
                    stock.Available_Quantity__c =wrapper.stock;
                    stock.Spare_Part__c = spMap.get(wrapper.material);
                    stock.MatetialPlant__c = wrapper.material + wrapper.plant;
                    stock.Name = wrapper.material +' - '+ wrapper.plant;
                    stockList.add(stock);
                }
                if(stockList.size() > 0)
                {
                    //system.debug('upsert---2');
                    upsert stockList MatetialPlant__c;
                }
            }

        } catch(Exception e) {
            System.debug(e);
        }

    }

    public void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
    //public void upsertSparePartStock()
    //{




}