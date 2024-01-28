codeunit 50100 "Substitute Report"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterSubstituteReport', '', false, false)]
    local procedure OnSubstituteReport(ReportId: Integer; var NewReportId: Integer)
    begin
        // if ReportId = Report::"Customer - List" then
        //     NewReportId := Report::"My New Customer - List";
    end;
}