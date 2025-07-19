<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="TicketServiceDesk.Admin" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
      <title>Login Form</title>
</head>
<body>
    <div style="width: 400px; margin: 0 auto; padding: 20px; border: 1px solid #ccc;background-color:#e6f2ff; height: 222px;">
        <form id="AdminForm" runat="server">
            <div>
                 <h2>Admin's login Page</h2>
                <asp:Label ID="lblEmail" runat="server" Text="Enter Email: " />
                <asp:TextBox ID="txtAdminEmail" runat="server"/><br /><br />

                 <asp:Label ID="lblPassword" runat="server" Text="Enter Password: " />
                <asp:TextBox ID="txtAdminPassword" runat="server" /><br /><br />

                <asp:Button ID="btnLogin" runat="server" Text="Login" OnClick="btnLogin_Click" /><br />
                <asp:Label ID="lblAdminMsg" runat="server" ForeColor="Red" /><br /><br />
            </div>
        </form>
     </div>
</body>
</html>
