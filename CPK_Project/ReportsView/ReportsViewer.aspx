<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReportsViewer.aspx.cs" Inherits="CPK_Project.ReportView.ReportsViewer" %>

<%@ Register assembly="Microsoft.ReportViewer.WebForms, Version=12.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91" namespace="Microsoft.Reporting.WebForms" tagprefix="rsweb" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CPK ReportViewer</title>
    <script src="../Scripts/jquery-2.1.4.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            showPrintButton();
            // Check if the current browser is IE (MSIE is not used since IE 11)
            var isIE = /MSIE/i.test(navigator.userAgent) || /rv:11.0/i.test(navigator.userAgent);

            function printReport() {

                var reportViewerName = 'reportViewer'; //Name attribute of report viewer control.
                var src_url = $find(reportViewerName)._getInternalViewer().ExportUrlBase + 'PDF';

                var contentDisposition = 'AlwaysInline'; //Content Disposition instructs the server to either return the PDF being requested as an attachment or a viewable report.
                var src_new = src_url.replace(/(ContentDisposition=).*?(&)/, '$1' + contentDisposition + '$2');

                var iframe = $('<iframe>', {
                    src: src_new,
                    id: 'pdfDocument',
                    frameborder: 0,
                    scrolling: 'no'
                }).hide().load(function () {
                    var PDF = document.getElementById('pdfDocument');
                    PDF.focus();
                    try {
                        PDF.contentWindow.print();
                    }
                    catch (ex) {
                        //If all else fails, we want to inform the user that it is impossible to directly print the document with the current browser.
                        //Instead, let's give them the option to export the pdf so that they can print it themselves with a 3rd party PDF reader application.

                        if (confirm("ActiveX and PDF Native Print support is not supported in your browser. The system is unable to print your document directly. Would you like to download the PDF version instead? You may print the document by opening the PDF using your PDF reader application.")) {
                            window.open($find(reportViewerName)._getInternalViewer().ExportUrlBase + 'PDF');
                        }
                    }

                })

                //Bind the iframe we created to an invisible div.
                $('.pdf').html(iframe);


            }

            // 2. Add Print button for non-IE browsers
            if (!isIE) {

                $('#PrintButton').click(function (e) {
                    e.preventDefault();
                    printReport();
                })
            }

        });

        function showPrintButton() {

            var table = $("table[title='Refresh']");

            var parentTable = $(table).parents('table');

            var parentDiv = $(parentTable).parents('div').parents('div').first();

            parentDiv.append('<input id="PrintButton" title="Print" style="width: 16px; height: 16px;" type="image" alt="Print" runat="server" src="~/Reserved.ReportViewerWebControl.axd?OpType=Resource&amp;Version=12.0.3442.2&amp;Name=Microsoft.Reporting.WebForms.Icons.Print.gif" />');



        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <rsweb:ReportViewer ID="reportViewer" runat="server" Width="99.9%" Height="100%" AsyncRendering="true" ZoomMode="Percent"  ShowPrintButton="False" ShowZoomControl="False">
        </rsweb:ReportViewer>
    
    </div>
    <div class="pdf">
    </div>
    </form>
</body>
</html>
