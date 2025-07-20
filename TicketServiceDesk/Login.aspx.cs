using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Drawing;

namespace TicketServiceDesk
{
    public partial class Admin : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            if (!Validation.IsValidEmail(email))
            {
                lblMsg.Text = "Please enter a valid email address.";
                lblMsg.ForeColor = System.Drawing.Color.Red;
                return;
            }
            string password = txtPassword.Text.Trim();

            string connStr = ConfigurationManager.ConnectionStrings["ServiceDeskConnectionString"].ConnectionString;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT UserName, Role FROM [Users] WHERE Email = @Email AND PasswordHash = @PasswordHash";
                SqlCommand cmd = new SqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@PasswordHash", password);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.HasRows)
                {
                    // Login successful
                    reader.Read();
                    string role = reader["Role"].ToString().ToLower();

                    // Redirect based on role
                    if (role == "admin")
                    {
                        Response.Redirect("AdminDashboard.aspx");
                    }
                    else if (role == "user")
                    {
                        Response.Redirect("UserDashboard.aspx?email=" + email);
                    }
                }
                else
                {
                    lblMsg.Text = "Invalid username or password.";
                }
            }
        }
    
    }
}