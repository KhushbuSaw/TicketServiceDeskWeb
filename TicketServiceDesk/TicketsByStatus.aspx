<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TicketsByStatus.aspx.cs" Inherits="TicketServiceDesk.TicketsByStatus" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Ticket Details</title>
</head>

<body>
    <form id="form1" runat="server" style="background-color:#e6f2ff">
        <h2>Ticket Details - <asp:Label ID="lblStatus" runat="server" /></h2>

        <asp:GridView ID="gvTickets" runat="server" AutoGenerateColumns="False" OnRowCommand="gvTickets_RowCommand" Height="264px" Width="1205px">
            <Columns>
                <asp:BoundField DataField="TicketID" HeaderText="ID" ReadOnly="true" />
                <asp:BoundField DataField="UserName" HeaderText="Raised By" />
                <asp:BoundField DataField="Email" HeaderText="Email" />
                <asp:BoundField DataField="TicketType" HeaderText="Type" />
                <asp:BoundField DataField="Status" HeaderText="Status" />
                <asp:BoundField DataField="CreatedDate" HeaderText="Raised on" />

                <asp:TemplateField HeaderText="Assign To">
                    <ItemTemplate>
                        <asp:TextBox ID="txtAssignTo" runat="server" Placeholder="Enter email" Text='<%# Eval("AssignedTo") %>' />
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Delivery Date">
                    <ItemTemplate>
                        <asp:TextBox ID="txtDeliveryDate" runat="server" TextMode="Date" />
                    </ItemTemplate>
                </asp:TemplateField>

                 <asp:TemplateField>
                     <ItemTemplate>
                         <asp:Button ID="btnUpdateAndMail" runat="server" CommandName="UpdateAndMailTicket" CommandArgument='<%# Eval("TicketID") %>' Text="Send Mail & Save" />
                     </ItemTemplate>
                 </asp:TemplateField>

                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="btnUpdate" runat="server" CommandName="UpdateTicket" CommandArgument='<%# Eval("TicketID") %>' Text="Save" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView><br />

        <asp:Label ID="lblMessage" runat="server" ForeColor="Green" />
    </form>
</body>
</html>
