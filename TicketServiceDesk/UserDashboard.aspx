<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserDashboard.aspx.cs" Inherits="TicketServiceDesk.UserDashboard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .grid {}
    </style>
</head>
<body>
   
    <form id="UserDashboardForm" runat="server">
        <div style="display: flex; float:left;">
         <div style="width: 70%; margin: 0 auto; padding: 20px; border: 1px solid #ccc;background-color:#e6f2ff; height: 550px;">
                  <div style="text-align: right;">
                     <asp:Button ID="btnLogout" runat="server" Text="Logout" OnClick="btnLogout_Click" />
                 </div>
                  <h2>My Assigned Tickets</h2>
                  <asp:GridView ID="gvTickets" runat="server" AutoGenerateColumns="False" CssClass="grid" OnRowCommand="gvUserTickets_RowCommand" OnRowDataBound="gvUserTickets_RowDataBound" Height="161px" Width="923px">
                  <Columns>
                      <asp:BoundField DataField="TicketID" HeaderText="Ticket Id" ReadOnly="true" />
                      <asp:BoundField DataField="RaisedByUserName" HeaderText="Raised By" />
                      <asp:BoundField DataField="RaisedByUserEmail" HeaderText="Raised By Email" />
                      <asp:BoundField DataField="TicketType" HeaderText="Ticket Type" />
                      <asp:BoundField DataField="Description" HeaderText="Remarks" />
                      <asp:BoundField DataField="CreatedDate" HeaderText="Raised on" />
                      <asp:BoundField DataField="DeliveryDate" HeaderText="Delivery Date" />
                      <asp:TemplateField HeaderText="Days Left">
                        <ItemTemplate>
                            <asp:Label ID="lblDaysLeft" runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Current Status">
                        <ItemTemplate>
                            <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("Status") %>' />
                            <asp:DropDownList ID="ddlStatus" runat="server" Visible="false">
                                <asp:ListItem Text="Open" />
                                <asp:ListItem Text="Work-in-progress" />
                                <asp:ListItem Text="Resolved" />
                                <asp:ListItem Text="Closed" />
                            </asp:DropDownList>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                       <ItemTemplate>
                        <asp:Button ID="btnEdit" runat="server" CommandName="EditTicket" Text="Change Status"
                            CommandArgument='<%# Eval("TicketID") + "|" + Eval("Status") + "|" + Request.QueryString["email"] %>' />
                        <asp:Button ID="btnSave" runat="server" CommandName="SaveTicket" Text="Save"
                            CommandArgument='<%# Eval("TicketID") + "|" + Request.QueryString["email"] %>' Visible="false" />
                       </ItemTemplate>
                    </asp:TemplateField>
                     <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Button ID="btnStartConversation" runat="server" Text="Chat About Ticket"
                                OnClick="btnStartConversation_Click" CommandArgument='<%# Eval("TicketID") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>

        <div style="width:30%;padding-top:100px;padding-left:20px;">
            <div style="width:400px;background-color=#e6f2ff;">
            <asp:Panel ID="pnlConversation" runat="server" Visible="false">
                <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="4" Columns="50" placeholder="Enter your message here"></asp:TextBox>
                <br /><br />
                <asp:FileUpload ID="fileUpload" runat="server" />
                <br /><br />
                <asp:Button ID="btnSendMessage" runat="server" Text="Send Message" OnClick="btnSendMessage_Click" />
            </asp:Panel>
            </div><br />
            <div style="width:400px;height: 200px; overflow-y: auto;">
            <asp:Panel ID="pnlHeader" runat="server" Visible="false">
                <h3>Past Conversation</h3>
            </asp:Panel>
            <asp:Repeater ID="rptConversation" runat="server">
               <ItemTemplate>
                <div style="margin-bottom: 10px; border-bottom: 1px solid #ccc;">
                    <%# Eval("MessageText") %>

                    <asp:Button ID="btnDownload" runat="server"
                        Text="📎 Download Attachment"
                        CommandName="Download"
                        CommandArgument='<%# Eval("FilePath") %>'
                        Visible='<%# !string.IsNullOrEmpty(Eval("FilePath").ToString()) %>' 
                        OnCommand="btnDownload_Command" />
                </div>
        </ItemTemplate>
        </asp:Repeater>
        </div>
        </div>
         </div>
        </form>
</body>
</html>
