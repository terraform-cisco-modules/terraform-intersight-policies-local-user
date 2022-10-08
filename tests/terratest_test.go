package test

import (
	"fmt"
	"os"
	"testing"

	iassert "github.com/cgascoig/intersight-simple-go/assert"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestFull(t *testing.T) {
	//========================================================================
	// Setup Terraform options
	//========================================================================

	// Generate a unique name for objects created in this test to ensure we don't
	// have collisions with stale objects
	uniqueId := random.UniqueId()
	instanceName := fmt.Sprintf("test-local-user-%s", uniqueId)

	// Input variables for the TF module
	vars := map[string]interface{}{
		"apikey":                os.Getenv("IS_KEYID"),
		"secretkeyfile":         os.Getenv("IS_KEYFILE"),
		"local_user_password_1": os.Getenv("USER_PASS"),
		"name":                  instanceName,
	}

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "./full",
		Vars:         vars,
	})

	//========================================================================
	// Init and apply terraform module
	//========================================================================
	defer terraform.Destroy(t, terraformOptions) // defer to ensure that TF destroy happens automatically after tests are completed
	terraform.InitAndApply(t, terraformOptions)
	moid := terraform.Output(t, terraformOptions, "moid")
	user := terraform.Output(t, terraformOptions, "user")
	user_role := terraform.Output(t, terraformOptions, "user_role")
	assert.NotEmpty(t, moid, "TF module moid output should not be empty")
	assert.NotEmpty(t, user, "TF module user moid output should not be empty")
	assert.NotEmpty(t, user_role, "TF module user_role moid output should not be empty")

	// Input variables for the TF module
	vars2 := map[string]interface{}{
		"name":        instanceName,
		"user":        user,
		"user_policy": moid,
		"user_role":   user_role,
	}

	//========================================================================
	// Make Intersight API call(s) to validate module worked
	//========================================================================

	// Setup the expected values of the returned MO.
	// This is a Go template for the JSON object, so template variables can be used
	expectedJSONTemplate := `
{
	"Name":        "{{ .name }}",
	"Description": "{{ .name }} Local User Policy.",

	"PasswordProperties": {
        "ClassId": "iam.EndPointPasswordProperties",
        "EnablePasswordExpiry": false,
        "EnforceStrongPassword": true,
        "ForceSendPassword": false,
        "GracePeriod": 0,
        "NotificationPeriod": 15,
        "ObjectType": "iam.EndPointPasswordProperties",
        "PasswordExpiryDuration": 90,
        "PasswordHistory": 5
	},
}
`
	// Validate that what is in the Intersight API matches the expected
	// The AssertMOComply function only checks that what is expected is in the result. Extra fields in the
	// result are ignored. This means we don't have to worry about things that aren't known in advance (e.g.
	// Moids, timestamps, etc)
	iassert.AssertMOComply(t, fmt.Sprintf("/api/v1/iam/EndPointUserPolicies/%s", moid), expectedJSONTemplate, vars2)

	// Setup the expected values of the returned MO.
	// This is a Go template for the JSON object, so template variables can be used
	expectedUSERTemplate := `
{
	"EndPointUserRole": [
		{
		  "ClassId": "mo.MoRef",
		  "Moid": "{{ .user_role }}",
		  "ObjectType": "iam.EndPointUserRole",
		  "link": "https://www.intersight.com/api/v1/iam/EndPointUserRoles/{{ .user_role }}"
		}
	],
	"Name": "admin",
}
`
	// Validate that what is in the Intersight API matches the expected
	// The AssertMOComply function only checks that what is expected is in the result. Extra fields in the
	// result are ignored. This means we don't have to worry about things that aren't known in advance (e.g.
	// Moids, timestamps, etc)
	iassert.AssertMOComply(t, fmt.Sprintf("/api/v1/iam/EndPointUserPolicies/%s", user), expectedUSERTemplate, vars2)

}
