/give @p cake 1 0 
{
  Unbreakable:1,
  CanDestroy:
  [
    stained_glass,
    nether_brick_fence,
    fence_gate
  ],
  CanPlaceOn:
  [
    pumpkin,
    diamond_block
  ],
  ench:
  [
    {
      id:16,
      lvl:3
    },
    {
      id:17,
      lvl:4
    },
    {
      id:34,
      lvl:3
    }
  ],
  AttributeModifiers:
  [
    {
      AttributeName:generic.attackDamage,
      Amount:10,
      Name:Extraschaden,
      Operation:0,
      UUIDLeast:1,
      UUIDMost:1
    }
  ]
}