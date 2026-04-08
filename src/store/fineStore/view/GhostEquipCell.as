package store.fineStore.view
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.utils.DoubleClickManager;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import store.equipGhost.EquipGhostManager;
   import store.equipGhost.EquipGhostEvent;
   
   public class GhostEquipCell extends BagCell
   {
       
      
      public function GhostEquipCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true, param4:DisplayObject = null, param5:Boolean = true)
      {
         super(param1,param2,param3,param4,param5);
      }
	  
	  override public function set info(param1:ItemTemplateInfo) : void
	  {
		  EquipGhostManager.getInstance().chooseEquip(param1 as InventoryItemInfo);
		  super.info = param1;
	  }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.enableDoubleClick(this);
		 EquipGhostManager.instance.addEventListener(EquipGhostManager.EQUIP_MOVE,this.equipMoveHandler);
		 EquipGhostManager.instance.addEventListener(EquipGhostManager.EQUIP_MOVE2,this.equipMoveHandler2);
      }
      
      private function equipMoveHandler(param1:EquipGhostEvent) : void
      {
         var _loc2_:EquipGhostEvent = null;
         if(info == param1.info)
         {
            return;
         }
         if(Boolean(info))
         {
            _loc2_ = new EquipGhostEvent(EquipGhostManager.EQUIP_MOVE2);
            _loc2_.info = info as InventoryItemInfo;
            _loc2_.moveType = 3;
			EquipGhostManager.instance.dispatchEvent(_loc2_);
         }
         info = param1.info;
      }
      
      private function equipMoveHandler2(param1:EquipGhostEvent) : void
      {
         if(info != param1.info || param1.moveType != 2)
         {
            return;
         }
         info = null;
		 EquipGhostManager.getInstance().clearEquip();
      }
      
      protected function __doubleClickHandler(param1:InteractiveEvent) : void
      {
         if(!info)
         {
            return;
         }
         SoundManager.instance.play("008");
         var _loc2_:EquipGhostEvent = new EquipGhostEvent(EquipGhostManager.EQUIP_MOVE2);
         _loc2_.info = info as InventoryItemInfo;
         _loc2_.moveType = 2;
		 EquipGhostManager.instance.dispatchEvent(_loc2_);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.disableDoubleClick(this);
		 EquipGhostManager.instance.removeEventListener(EquipGhostManager.EQUIP_MOVE,this.equipMoveHandler);
		 EquipGhostManager.instance.removeEventListener(EquipGhostManager.EQUIP_MOVE2,this.equipMoveHandler2);
      }
      
      protected function __clickHandler(param1:InteractiveEvent) : void
      {
         SoundManager.instance.play("008");
         dragStart();
      }
      
      public function clearInfo() : void
      {
         var _loc1_:EquipGhostEvent = null;
         if(Boolean(info))
         {
            _loc1_ = new EquipGhostEvent(EquipGhostManager.EQUIP_MOVE2);
            _loc1_.info = info as InventoryItemInfo;
            _loc1_.moveType = 2;
			EquipGhostManager.instance.dispatchEvent(_loc1_);
         }
      }
   }
}
