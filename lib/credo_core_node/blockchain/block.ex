defmodule CredoCoreNode.Blockchain.Block do
  # TODO:
  #   1. State and receipts are currently placeholders that are always empty; to be implemented
  #   2. Various additional data needed by smart contracts and light clients; to be designed
  use Mnesia.Schema,
    table_name: :blocks,
    fields: [:hash, :prev_hash, :number, :state_root, :receipt_root, :tx_root],
    virtual_fields: [:body],
    rlp_support: :true

  alias CredoCoreNode.Blockchain.Block

  def to_list(%Block{} = blk, _options) do
    [blk.prev_hash, blk.number, blk.state_root, blk.receipt_root, blk.tx_root]
  end
end
