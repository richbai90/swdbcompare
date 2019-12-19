ALTER TABLE opencall 
ADD h_condition INT ;
ALTER TABLE opencall 
ADD h_formattedcallref VARCHAR (16) ;
ALTER TABLE rcinfo 
ADD flags INT ;
ALTER TABLE userdb_site 
ADD pk_auto_id INT PRIMARY KEY NOT NULL;
