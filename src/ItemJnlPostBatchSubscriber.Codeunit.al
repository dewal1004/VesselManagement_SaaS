codeunit 50017 "ItemJnlPostBatchSubscriber"
{
    EventSubscriberInstance = StaticAutomatic;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Batch", 'OnBeforeCheckLines', '', true, true)]
    local procedure ItemJnlLnPostBatcOnBeforeCheckLines(var ItemJnlLine: Record "Item Journal Line")
    begin
        InventSU.Get();
        if (ItemJnlLine."Reason Code" = InventSU."FA Acquisition") and (ItemJnlLine."External Document No." <> '') then begin
            FAUseReaCd := InventSU."FA Acquisition";
            FAJourlTemp := InventSU."FA Acquisition Template";
            IJL(ItemJnlLine);
        end
        else
            if (ItemJnlLine."Reason Code" = InventSU."FA Maintenance") and (ItemJnlLine."External Document No." <> '') then begin
                FAUseReaCd := InventSU."FA Maintenance";
                FAJourlTemp := InventSU."FA Maintenance Template";
                IJLM(ItemJnlLine);
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Batch", 'OnPostLinesOnBeforePostLine', '', true, true)]
    local procedure ItemJnlLnPostBatcOnPostLinesOnBeforePostLine(var ItemJournalLine: Record "Item Journal Line")
    begin
        if (ItemJournalLine."Reason Code" = FAUseReaCd) and (ItemJournalLine."External Document No." <> '') then
            //Posting of Acquisition Cost for FA GL
            if REC.Get(FAJourlTemp, ItemJournalLine."Journal Batch Name", ItemJournalLine."Line No.") then begin
                REC."Ready to Post" := true;
                REC.Modify();
            end;
    end;

    Var
        REC: Record "Gen. Journal Line";
        InventSU: Record "Inventory Setup";
        FAUseReaCd: Code[10];
        FAJourlTemp: Code[20];

    procedure IJL(VAR ItemJL: Record "Item Journal Line");
    Var
        FAJnlTemplate: Record "Gen. Journal Template";
        FAJnlLine: Record "Gen. Journal Line";
        FAJnlBatch: Record "Gen. Journal Batch";
        GenPostgSetup: Record "General Posting Setup";
    BEGIN
        InventSU.Get();
        if not FAJnlTemplate.Get(InventSU."FA Acquisition Template") then begin
            FAJnlTemplate.Init();
            FAJnlTemplate.Name := InventSU."FA Acquisition Template";
            FAJnlTemplate.Insert();
        end;

        if not FAJnlBatch.Get(InventSU."FA Acquisition Template", ItemJL."Journal Batch Name") then begin
            FAJnlBatch.Init();
            FAJnlBatch."Journal Template Name" := InventSU."FA Acquisition Template";
            FAJnlBatch.Name := ItemJL."Journal Batch Name";
            FAJnlBatch.Description := 'Inventory Tranfer to Fixed Asset';
            FAJnlBatch.Insert();
        end;

        FAJnlLine.SetRange("Journal Template Name", InventSU."FA Acquisition Template");
        FAJnlLine.SetRange("Journal Batch Name", ItemJL."Journal Batch Name");

        FAJnlLine.Init();
        FAJnlLine."Journal Template Name" := InventSU."FA Acquisition Template";
        FAJnlLine."Journal Batch Name" := ItemJL."Journal Batch Name";
        FAJnlLine."Line No." := ItemJL."Line No.";
        FAJnlLine."Account Type" := FAJnlLine."Account Type"::"Fixed Asset";
        FAJnlLine."Account No." := ItemJL."External Document No.";
        FAJnlLine."External Document No." := ItemJL."External Document No.";
        FAJnlLine."Reason Code" := ItemJL."Reason Code";
        FAJnlLine.Validate(FAJnlLine."Account No.");
        FAJnlLine.Description := 'Acquisition of ' + ItemJL.Description;
        FAJnlLine."Posting Date" := ItemJL."Posting Date";
        FAJnlLine."Document No." := ItemJL."Document No.";
        //FAJnlLine."Maintenance Code":=FORMAT(ItemJL."Issue Type");
        FAJnlLine.Validate(FAJnlLine.Amount, ItemJL.Amount);
        FAJnlLine."FA Posting Type" := FAJnlLine."FA Posting Type"::"Acquisition Cost";
        FAJnlLine."FA Posting Date" := ItemJL."Posting Date";
        FAJnlLine."Shortcut Dimension 1 Code" := ItemJL."Shortcut Dimension 1 Code";
        FAJnlLine."Shortcut Dimension 2 Code" := ItemJL."Shortcut Dimension 2 Code";
        FAJnlLine."Source Code" := 'INVTOFA';

        if GenPostgSetup.Get(ItemJL."Gen. Bus. Posting Group", ItemJL."Gen. Prod. Posting Group")
        then
            //FAJnlLine."Bal. Account No.":=GenPostgSetup."Purch. Account"
            FAJnlLine."Bal. Account No." := GenPostgSetup."Inventory Adjmt. Account"
        else
            Error('The Posting Group Combination thus not EXIST');
        if FAJnlLine."Bal. Account No." = '' then
            Error('The Posting Group Combination thus not have purchase account no');
        FAJnlLine.Insert();
    END;

    Procedure IJLM(VAR ItemJL: Record "Item Journal Line");
    VAR
        FAJnlTemplate: Record "Gen. Journal Template";
        FAJnlLine: Record "Gen. Journal Line";
        FAJnlBatch: Record "Gen. Journal Batch";
        GenPostgSetup: Record "General Posting Setup";
    BEGIN
        //AAA
        InventSU.Get();
        if not FAJnlTemplate.Get(InventSU."FA Maintenance Template") then begin
            FAJnlTemplate.Init();
            FAJnlTemplate.Name := InventSU."FA Maintenance Template";
            FAJnlTemplate.Insert();
        end;

        if not FAJnlBatch.Get(InventSU."FA Maintenance Template", ItemJL."Journal Batch Name") then begin
            FAJnlBatch.Init();
            FAJnlBatch."Journal Template Name" := InventSU."FA Maintenance Template";
            FAJnlBatch.Name := ItemJL."Journal Batch Name";
            FAJnlBatch.Description := 'Inventory Tranfer to Fixed Asset';
            FAJnlBatch.Insert();
        end;

        FAJnlLine.SetRange("Journal Template Name", InventSU."FA Maintenance Template");
        FAJnlLine.SetRange("Journal Batch Name", ItemJL."Journal Batch Name");
        FAJnlLine.Init();
        FAJnlLine."Journal Template Name" := InventSU."FA Maintenance Template";
        FAJnlLine."Journal Batch Name" := ItemJL."Journal Batch Name";
        FAJnlLine."Line No." := ItemJL."Line No.";
        FAJnlLine."Account Type" := FAJnlLine."Account Type"::"Fixed Asset";
        FAJnlLine."Account No." := ItemJL."External Document No.";
        FAJnlLine."External Document No." := ItemJL."External Document No.";
        FAJnlLine."Reason Code" := ItemJL."Reason Code";
        FAJnlLine.Validate(FAJnlLine."Account No.");
        FAJnlLine.Description := 'Maintenance With ' + ItemJL.Description;
        FAJnlLine."Posting Date" := ItemJL."Posting Date";
        FAJnlLine."Document No." := ItemJL."Document No.";
        FAJnlLine."Maintenance Code" := Format(ItemJL."Issue Type");
        if (ItemJL."Entry Type" = ItemJL."Entry Type"::" ") or (ItemJL."Entry Type" = ItemJL."Entry Type"::"Assembly Output") then
            ItemJL.Amount := ItemJL.Amount * -1;
        FAJnlLine.Validate(FAJnlLine.Amount, ItemJL.Amount);
        FAJnlLine."FA Posting Type" := FAJnlLine."FA Posting Type"::Maintenance;
        FAJnlLine."FA Posting Date" := ItemJL."Posting Date";
        FAJnlLine."Shortcut Dimension 1 Code" := ItemJL."Shortcut Dimension 1 Code";
        FAJnlLine."Shortcut Dimension 2 Code" := ItemJL."Shortcut Dimension 2 Code";
        FAJnlLine."Source Code" := 'INVTOFA';

        if GenPostgSetup.Get(ItemJL."Gen. Bus. Posting Group", ItemJL."Gen. Prod. Posting Group")
        then
            FAJnlLine."Bal. Account No." := GenPostgSetup."Inventory Adjmt. Account"
        else
            Error('The Posting Group Combination thus not EXIST');
        if FAJnlLine."Bal. Account No." = '' then
            Error('The Posting Group Combination thus not have purchase account no');
        if not FAJnlLine.Insert() then FAJnlLine.Modify();
    END;
}