/****************************************************************************
* Smartsheet Object Class
----------------------------------------------------------------------------------
*History
*Version       Date       DETAIL FEATURES
  1.0         09/06/2014   Describes Smartsheet object class          
*****************************************************************************/
public class Smartsheet {

    /* 
     * Represent Smartsheet Sheet object
     */
    public class Sheet {
        public List<String> effectiveAttachmentOptions;
        public Long id;
        public String name;
        public Integer version;
        public List<Column> columns;
        public List<Row> rows;
        public String accessLevel;
        public Boolean ganttEnabled;
        public Boolean dependenciesEnabled;
        public Boolean resourceManagementEnabled;
        public String permalink;
        public String createdAt;
        public String modifiedAt;
        


        /*
         *  getter/seter are only needed to access from VF page
         */
        public Long getId() {
            return id;
        }
        public void setId(Long id) {
            this.id = id;
        }
        public String getName() {
            return name;
        }
        public void setName(String name) {
            this.name = name;
        }
        public String getAccessLevel() {
            return accessLevel;
        }
        public List<Column> getColumns() {
            return columns;
        }
        public void setColumns(List<Column> columns) {
            this.columns = columns;
        }
        public List<Row> getRows() {
            return rows;
        }
        public void setRows(List<Row> rows) {
            this.rows = rows;
        }
        public Boolean getGanttEnabled() {
            return ganttEnabled;
        }
        public Boolean getDependenciesEnabled() {
            return dependenciesEnabled;
        }
        public Boolean getResourceManagementEnabled() {
            return resourceManagementEnabled;
        }
    }

    /*
     * Represent Smartsheet Row object
     */
    public class Row {
        public Long id;
        public Long sheetId;
        public Long rowNumber;
        public Boolean expanded;
        public List<Cell> cells;
        public Long version;
        public String createdAt;
        public String modifiedAt;
        public Long columnId;
        public String type;
        public String value;
        public Integer parentRowNumber;
        public Boolean locked;
        public String lockedForUser;

        /*
         * getter/seter are only needed to access from VF page
         */
        public Long getId() {
            return id;
        }
        public void setId(Long id) {
            this.id = id;
        }
        public Long getSheetId() {
            return sheetId;
        }
        public void setSheetId(Long id) {
            this.sheetId = sheetId;
        }
        public Long getRowNumber() {
            return rowNumber;
        }
        public void setRowNumber(Long rowNumber) {
            this.rowNumber = rowNumber;
        }
        public List<Cell> getCells() {
            return cells;
        }
        public void setCells(List<Cell> cells) {
            this.cells = cells;
        }
        public Long getVersion() {
            return version;
        }
        public Long getColumnId() {
            return columnId;
        }
        public String getType() {
            return type;
        }
        public String getValue() {
            return value;
        }
         public Long getParentRowNumber() {
            return parentRowNumber;
        }
    }

    /*
     * Represent Smartsheet Column object
     */
    public class Column {
        public Long id;
        public Integer index;
        public String symbol;
        public String title;
        public String type;
        public Boolean primary;
        public List<String> options;
        public Integer width;
        public List<String> tags;
        public Boolean locked;
        public Boolean hidden;
        public String lockedForUser;


        /*
         * getter/seter are only needed to access from VF page
         */
        public Long getId() {
            return id;
        }
        public Integer getIndex() {
            return index;
        }
        public String getTitle() {
            return title;
        }
        public void setTitle(String title) {
            this.title = title;
        }
        public String getType() {
            return type;
        }
        public void setType(String type) {
            this.type = type;
        }
        public Boolean getPrimary() {
            return primary;
        }
        public Integer getWidth() {
            return width;
        }
        
    }

    /*
     * represent Smartsheet Cell object
     */
    public class Cell {
        public String type;
        public String value;
        public String displayValue;
        public Long columnId;
        public Long rowId;
        public String link;
        public Boolean strict;
        public String formula;
       // public String format;
        public Long sheetId;


        /*
         * getter/seter are only needed to access from VF page
         */
        public String getType() {
            return type;
        }
        public void setType(String type) {
            this.type = type;
        }
        public String getValue() {
            return value;
        }
        public void setValue(String value) {
            this.value = value;
        }
        public String getDisplayValue() {
            return displayValue;
        }
        public Long getColumnId() {
            return columnId;
        }
        public void setColumnId(Long columnId) {
            this.columnId = columnId;
        }
        public Long getRowId() {
            return rowId;
        }
        public void setRowId(Long rowId) {
            this.rowId = rowId;
        }
        public Boolean getStrict() {
            return strict;
        }
        public void setStrict(Boolean strict) {
            this.strict = strict;
        }
    }

    /*
     * represent Smartsheet AccessToken response object
     */
    public class AccessToken {
        public String access_token;
        public String token_type;
        public String refresh_token;
        public Integer expires_in;

        public String getAccessToken() {
            return access_token;
        }
    }

    /* 
     * represent json model for Smartsheet Sheet-manupluating method response
     */
    public class SheetResult {
        public String message;
        public Integer resultCode;
        public Sheet result;
        public Long id;
        public String permalink;
        public Integer version;
        /*
         *  getter/seter are only needed to access from VF page
         */
        public String getPermalink() {
            return permalink;
        }
        public void setPermalink(String permalink) {
            this.permalink = permalink;
        }
        public Integer getVersion() {
            return version;
        }
    }

    /*
     * represent json model for Smartsheet InserRows method
     */
    public class InsertRows {
        public Boolean toTop;
        public Boolean toBottom;
        public Long parentId;
        public Long siblingId;
        public List<Row> rows;

        public List<Row> getRows() {
            return rows;
        }
    }

    public class RowsResult {
        public String message;
        public Integer resultCode;
        public List<Row> result;
        public Integer version;
    }
    
    public class RestError {
        public String error;
        public String message;
        public Integer errorCode;
    }
    
    /*
     * represent Smartsheet Template object
     */
     public class Template {
        public Long id;
        public String name;
        public String accessLevel;
        public String description;
        
        /*
         *  getter/seter are only needed to access from VF page
         */
        public Long getId() {
            return id;
        }
        public void setId(Long id) {
            this.id = id;
        }
        public String getName() {
            return name;
        }
        public void setName(String name) {
            this.name = name;
        }
        public String getAccessLevel() {
            return accessLevel;
        }
        
    }
    /*
     * represent json model for Smartsheet UpdateCells method
     */
    public class updateCells {
        public List<Cell> cells;

        public List<Cell> getCells() {
            return cells;
        }
    }
    public class CellsResult {
        public String message;
        public Integer resultCode;
        public List<Cell> result;
        public Integer version;
    }
    /*
     * represent Smartsheet Publish object
     */
     public class sheetPublish {
        public Boolean readOnlyLiteEnabled;
        public Boolean icalEnabled;
        public Boolean readWriteEnabled;
        public Boolean readOnlyFullEnabled;
        public String readOnlyLiteUrl;
        public String readOnlyFullUrl;
        public String readWriteUrl;
        public String calUrl;
        /*
         *  getter/seter are only needed to access from VF page
         */
        public Boolean getReadOnlyLiteEnabled() {
            return readOnlyLiteEnabled;
        }
        public void setReadOnlyLiteEnabled(Boolean readOnlyLiteEnabled) {
            this.readOnlyLiteEnabled = readOnlyLiteEnabled;
        }
        public Boolean getIcalEnabled() {
            return icalEnabled;
        }
        public void setIcalEnabled(Boolean icalEnabled) {
            this.icalEnabled = icalEnabled;
        }
        public Boolean getReadWriteEnabled() {
            return readWriteEnabled;
        }
        public void setReadWriteEnabled(Boolean readWriteEnabled) {
            this.readWriteEnabled = readWriteEnabled;
        }
        public Boolean getReadOnlyFullEnabled() {
            return readOnlyFullEnabled;
        }
        public void setReadOnlyFullEnabled(Boolean readOnlyFullEnabled) {
            this.readOnlyFullEnabled = readOnlyFullEnabled;
        }
        public String getReadOnlyLiteUrl() {
            return readOnlyLiteUrl;
        }
        public String getReadOnlyFullUrl() {
            return readOnlyFullUrl;
        }
        public String getReadWriteUrl() {
            return readWriteUrl;
        }
        public String getCalUrl() {
            return calUrl;
        }
    }
    public class PublishResult {
        public String message;
        public Integer resultCode;
        public List<sheetPublish> result;
        public Integer version;
    }
    public class ShareWithGroups {
        public String Id;
        public String type;
        public Long groupId;
        public String name;
        public String accessLevel;
        public String email;
    }
  
    public class ShareGroup { 
        public Long Id;
        public String name; 
        public String accessLevel;
        public String description;
        public String owner;
        public Long ownerId;
        public String createdAt;
        public String modifiedAt;
        public String email;
    }  
    public class ShareGroupResult{
        public Integer resultCode;
        public ShareWithGroups result;
        public String message;
    }
    public class ShareUserResult{
        public Integer resultCode;
        public ShareGroup result;
        public String message;
    }
}