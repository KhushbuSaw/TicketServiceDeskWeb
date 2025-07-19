<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="TicketServiceDesk.AdminDashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .table {
            margin-left: 0px;
        }
    </style>
</head>
<body>
     <div style="width: 400px; margin: 0 auto; padding: 20px; border: 1px solid #ccc;background-color:#e6f2ff; height: 400px;">
       <h2>Ticket's Count Details</h2>
        <form id="form1" runat="server">
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
