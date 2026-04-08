package store.fineStore.view
{
   import flash.display.Sprite;
   
   import bagAndInfo.cell.DragEffect;
   
   import baglocked.BaglockedManager;
   
   import ddt.data.BagInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.interfaces.IAcceptDrag;
   import ddt.manager.DragManager;
   import ddt.manager.PlayerManager;
   
   import store.equipGhost.EquipGhostEvent;
   import store.equipGhost.EquipGhostManager;
   
   public class GhostEquipLeftDragSprite extends Sprite implements IAcceptDrag
   {
       
      
      public function GhostEquipLeftDragSprite()
      {
         super();
      }
      
      public function dragDrop(param1:DragEffect) : void
      {
         var _loc2_:String = null;
         DragManager.acceptDrag(this,DragEffect.NONE);
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc3_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(_loc3_.BagType == BagInfo.EQUIPBAG)
         {
            _loc2_ = EquipGhostManager.EQUIP_MOVE;
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
//			 trace("drag type:" + _type + " cat: " + _loc3_.CategoryID + " pro1: " + _loc3_.Property1);
			 if(_type == "") {
				 return;
			 }
			 _loc2_ = EquipGhostManager.ITEM_MOVE + _type;
         }
         var _loc4_:EquipGhostEvent = new EquipGhostEvent(_loc2_);
         _loc4_.info = _loc3_;
         _loc4_.moveType = 1;
		 EquipGhostManager.instance.dispatchEvent(_loc4_);
      }
   }
}
