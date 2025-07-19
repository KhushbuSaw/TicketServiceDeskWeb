using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TicketServiceDesk
{
    public partial class Admin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string gmail = txtAdminEmail.Text.Trim();
            if (!Validation.IsValidEmail(gmail))
            {
                lblAdminMsg.Text = "Please enter a valid email address.";
                lblAdminMsg.ForeColor = System.Drawing.Color.Red;
                return;
            }
            string password = txtAdminPassword.Text.Trim();

            string connStr = ConfigurationManager.ConnectionStrings["ServiceDeskConnectionString"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT COUNT(*) FROM Admin WHERE Gmail = @Gmail AND Password = @Password";

                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Gmail", gmail);
                cmd.Parameters.AddWithValue("@Password", password);

                try
                {
                    conn.Open();
                    int count = (int)cmd.ExecuteScalar();

                    if (count == 1)
                    {
                        Session["AdminEmail"] = gmail;
                        Response.Redirect("AdminDashboard.aspx");
                    }
                    else
                    {
                        lblAdminMsg.Text = "Invalid email or password.";
                        lblAdminMsg.ForeColor = System.Drawing.Color.Red;
                    }
                }
                catch (Exception ex)
                {
                    lblAdminMsg.Text = "Error: " + ex.Message;
                }
            }
        }
    
    }
}