<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="TicketServiceDesk.AdminDashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <title>Admin Dashboard</title>
    <style type="text/css">
        .table {
            margin-left: 0px;
        }
    </style>
</head>
<body>

     <div style="width: 400px; margin: 0 auto; padding: 20px; border: 1px solid #ccc;background-color:#e6f2ff; height: 400px;">
        <form id="form1" runat="server">
            <div style="text-align: right;">
                <asp:Button ID="btnLogout" runat="server" Text="Logout" OnClick="btnLogout_Click" />
            </div>
             <h2>Ticket's Count Details</h2>
          <div>
           <asp:GridView ID="gvTickets" runat="server" AutoGenerateColumns="False" CssClass="table" Height="323px" Width="358px" HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" RowStyle-HorizontalAlign="Center">
            <Columns>
                <asp:BoundField DataField="Status" HeaderText="Ticket" />
                <asp:BoundField DataField="TicketCount" HeaderText="Count" />
                <asp:TemplateField HeaderText="Ticket Details">
                    <ItemTemplate>
                        <asp:HyperLink 
                            ID="lnkDetails" 
                            runat="server" 
                              NavigateUrl='<%# "TicketsByStatus.aspx?status=" + Eval("Status") %>'
                            Text="View Details">
                        </asp:HyperLink>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
               <HeaderStyle HorizontalAlign="Center" />
               <RowStyle HorizontalAlign="Center" />
         </asp:GridView>
        </div>
      </form>
    </div>
</body>
</html>
