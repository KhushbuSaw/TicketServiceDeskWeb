using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;


namespace TicketServiceDesk
{
    public partial class Home : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string email = txtEmail.Text.Trim();
            if (!Validation.IsValidEmail(email))
            {
                lblMessage.Text = "Please enter a valid email address.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }
            string ticketType = ddlTicketType.SelectedValue;
            string description = txtDescription.Text.Trim();

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(ticketType))
            {
                lblMessage.Text = "Please fill in all fields.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }
            string connStr = ConfigurationManager.ConnectionStrings["ServiceDeskConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "INSERT INTO Tickets (RaisedByUserName, RaisedByUserEmail, TicketType, Description) VALUES (@RaisedByUserName, @RaisedByUserEmail, @TicketType, @Description)";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@RaisedByUserName", username);
                cmd.Parameters.AddWithValue("@RaisedByUserEmail", email);
                cmd.Parameters.AddWithValue("@TicketType", ticketType);
                cmd.Parameters.AddWithValue("@Description", description);

                try
                {
                    conn.Open();
                    cmd.ExecuteNonQuery();
                    lblMessage.Text = "Ticket submitted successfully!";
                    lblMessage.ForeColor = System.Drawing.Color.Green;

                    txtUsername.Text = "";
                    txtEmail.Text = "";
                    ddlTicketType.SelectedIndex = 0;
                    txtDescription.Text = "";
                }
                catch (Exception ex)
                {
                    lblMessage.Text = "Error: " + ex.Message;
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx");
        }
    }
}