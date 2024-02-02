codeunit 50101 TransferRecordsBatch
{
    procedure TransferDataBatch()
    var
        SourceTable: Record "Item Ledger Entry";
        DestinationTable: Record "ASL Item Ledger Entry Buffer";
        BatchSize: Integer;
        Count: Integer;
    begin
        BatchSize := 100; // Adjust the batch size as needed
        if SourceTable.FINDSET then // Open the source table
            repeat
                Count := 0;

                // Start a new transaction for each batch
                // DATABASE::StartTransaction; # is this in al

                // Transfer records in batches
                while Count < BatchSize do begin
                    // Copy data from the source to the destination table
                    DestinationTable.INIT;
                    // DestinationTable.Field1 := SourceTable.Field1;  #Try using field ref, refactor the following 2 lines 
                    // DestinationTable.Field2 := SourceTable.Field2;

                    // Other fields...

                    // Insert the record into the destination table
                    DestinationTable.INSERT;

                    // Move to the next record in the source table
                    if SourceTable.NEXT = 0 then
                        break; // No more records, exit the loop

                    Count += 1;
                end;

                // Commit the transaction for the current batch
                Commit();

            until SourceTable.NEXT = 0;

        // Optionally, you can perform additional logic after the batch processing is complete
    end;


    procedure TransferDataUsingCopyRecord()
    var
        SourceTable: Record "Item Ledger Entry";
        DestinationTable: Record "ASL Item Ledger Entry Buffer";
    begin
        // Open the source table
        if SourceTable.FINDSET then
            repeat
                // Initialize the destination record
                DestinationTable.INIT;

                // Copy fields from source to destination using CopyRecord
                DestinationTable.TransferFields(SourceTable);  //Recorc.copy is not working in SAAS

                // Insert the record into the destination table
                DestinationTable.INSERT;

            until SourceTable.NEXT = 0;
    end;


}
