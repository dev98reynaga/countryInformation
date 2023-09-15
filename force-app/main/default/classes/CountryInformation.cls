public class CountryInformation {
    public List<String> capital { get; set;}
    public Map<String, String> languages { get; set; }
    public Map<String, String> flags { get; set; }
    public Map<String, CurrencyInfo> currencies { get; set; }
    public NotFoundWrapper notFoundWrapper { get; set; }
 
    public class CurrencyInfo {
        public String name { get; set; }
    }

    public class NotFoundWrapper{
        public Integer status { get; set;}
        public String message { get; set;}
    }
}