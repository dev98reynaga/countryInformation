public class SObjectListHelper {

    public static List<List<SObject>> splitRecordList(List<SObject> records){
        Integer chuckSize = 50;
        Integer counter = 0;
        List<List<SObject>> recordChunks = new List<List<SObject>>();
        List<SObject> subsetRecords = new List<SObject>();

        for(SObject record: records){
            subsetRecords.add(record);
            counter++;
            if(counter == chuckSize){
                recordChunks.add(subsetRecords.deepClone());
                subsetRecords.clear();
                counter = 0;
            }
        }
        if(subsetRecords.size() > 0){
            recordChunks.add(subsetRecords.deepClone());
            subsetRecords.clear();
        }
        
        return recordChunks;
    }
}