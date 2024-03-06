#!/usr/bin/env bats

setup(){
    cd $BATS_TEST_DIRNAME
    cd ../..
    rm -f $BATS_RUN_TMPDIR/test_generated_manifests.yaml
}

@test "Pass when running nominal example" {
    helm template . \
        -f values-example.yaml \
        > $BATS_RUN_TMPDIR/test_generated_manifests.yaml
    [ "$?" -eq 0 ]

    kubeconform -debug -summary -strict \
        -schema-location '../catalog-crds-json-schema/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json' \
        -schema-location default $BATS_RUN_TMPDIR/test_generated_manifests.yaml
  [ "$?" -eq 0 ]
}

@test "Pass when running standard api" {
    helm template . \
        -f ../helm/tests/testcases/deployment/nominal.yaml \
        -f ../helm/tests/testcases/product/nominal.yaml \
        -f ./tests/testcases/component/base.yaml \
        > $BATS_RUN_TMPDIR/test_generated_manifests.yaml
    [ "$?" -eq 0 ]

    kubeconform -debug -summary -strict \
        -schema-location '../catalog-crds-json-schema/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json' \
        -schema-location default $BATS_RUN_TMPDIR/test_generated_manifests.yaml
    [ "$?" -eq 0 ]
}

@test "Pass when running nominal secrets API" {
    helm template .  \
        -f ../helm/tests/testcases/deployment/nominal.yaml \
        -f ../helm/tests/testcases/product/nominal.yaml \
        -f ./tests/testcases/component/base.yaml \
        -f ./tests/testcases/component/secrets/nominal.yaml \
        > $BATS_RUN_TMPDIR/test_generated_manifests.yaml
    [ "$?" -eq 0 ]

    kubeconform -debug -summary -strict \
        -schema-location '../catalog-crds-json-schema/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json' \
        -schema-location default $BATS_RUN_TMPDIR/test_generated_manifests.yaml
    [ "$?" -eq 0 ]
}

@test "Pass when running nominal wpa API" {
    helm template .  \
        -f ../helm/tests/testcases/deployment/nominal.yaml \
        -f ../helm/tests/testcases/product/nominal.yaml \
        -f ./tests/testcases/component/base.yaml \
        -f ./tests/testcases/component/wpa/nominal.yaml \
        > $BATS_RUN_TMPDIR/test_generated_manifests.yaml
    [ "$?" -eq 0 ]

    kubeconform -debug -summary -strict \
        -schema-location '../catalog-crds-json-schema/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json' \
        -schema-location default $BATS_RUN_TMPDIR/test_generated_manifests.yaml
    [ "$?" -eq 0 ]
}

@test "Pass when running fully fledged wpa API" {
    helm template .  \
        -f ../helm/tests/testcases/deployment/nominal.yaml \
        -f ../helm/tests/testcases/product/nominal.yaml \
        -f ./tests/testcases/component/base.yaml \
        -f ./tests/testcases/component/wpa/full.yaml \
        > $BATS_RUN_TMPDIR/test_generated_manifests.yaml
    [ "$?" -eq 0 ]

    kubeconform -debug -summary -strict \
        -schema-location '../catalog-crds-json-schema/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json' \
        -schema-location default $BATS_RUN_TMPDIR/test_generated_manifests.yaml
    [ "$?" -eq 0 ]
}
