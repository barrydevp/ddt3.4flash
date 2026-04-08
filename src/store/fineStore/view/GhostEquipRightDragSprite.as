package store.fineStore.view
{
   import bagAndInfo.cell.DragEffect;
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import flash.display.Sprite;
   import store.equipGhost.EquipGhostManager;
   import store.equipGhost.EquipGhostEvent;
   
   public class GhostEquipRightDragSprite extends Sprite implements IAcceptDrag
   {
       
      
      public function GhostEquipRightDragSprite()
      {
         super();
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
         var _loc2_:String = null;
         DragManager.acceptDrag(this,DragEffect.NONE);
         var _loc3_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(_loc3_.BagType == BagInfo.EQUIPBAG)
         {
            _loc2_ = EquipGhostManager.EQUIP_MOVE2;
         }
         else
         {
			 var _type: String = "";
			 if(_loc3_.CategoryID == 11)
			 {
				 if(_loc3_.Property1 == "117")
				 {
					 _type = EquipGhostManager.LUCK_TYPE;
				 }
				 else if(_loc3_.Property1 == "118"){
					 _type = EquipGhostManager.STONE_TYPE;
				 }
			 }
			 
			 if(_type == "") {
				 return;
			 }
			 _loc2_ = EquipGhostManager.ITEM_MOVE2 + _type;
         }
         var _loc4_:EquipGhostEvent = new EquipGhostEvent(_loc2_);
         _loc4_.info = _loc3_;
         _loc4_.moveType = 2;
		 EquipGhostManager.instance.dispatchEvent(_loc4_);
      }
   }
}
