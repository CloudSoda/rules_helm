package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/shell"
	"github.com/stretchr/testify/require"
)

// Test suite for testing helm lint
func TestChartLintSucess(t *testing.T) {
	shell.RunCommand(t, shell.Command{
		Command:    "bazel",
		Args:       []string{"test", "//tests/charts/nginx-lint/valid:nginx_lint"},
		WorkingDir: ".",
		Env:        map[string]string{},
	})
}

func TestChartLintFailure(t *testing.T) {
	err := shell.RunCommandE(t, shell.Command{
		Command:    "bazel",
		Args:       []string{"test", "//tests/charts/nginx-lint/invalid:nginx_lint"},
		WorkingDir: ".",
		Env:        map[string]string{},
	})
	require.Error(t, err)
}
