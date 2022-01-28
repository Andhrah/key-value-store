defmodule KV.BucketTest do
  use ExUnit.Case, async: true

  @doc """
  setup macro defines a callback that runs before every test, 
  in the same process as the test itself.
  """
  setup do
    # {:ok, bucket} = KV.Bucket.start_link([])
    bucket = start_supervised!(KV.Bucket)
    %{bucket: bucket}
  end

  test "store values by key", %{bucket: bucket} do
    # `bucket` is now bucket from the setup block
    assert KV.Bucket.get(bucket, "milk") == nil

    KV.Bucket.put(bucket, "milk", 3)
    assert KV.Bucket.get(bucket, "milk") == 3

    KV.Bucket.delete(bucket, "milk")
    assert KV.Bucket.get(bucket, "milk") == nil
  end

  test "are temporary workers" do
    assert Supervisor.child_spec(KV.Bucket, []).restart == :temporary
end