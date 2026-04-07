package store.view.exalt
{
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.CellContentCreator;
   
   import ddt.data.EquipType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.SoundManager;
   import ddt.view.tips.GoodTipInfo;
   
   public class ExaltEquipCell extends BagCell
   {
       
      
      public function ExaltEquipCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true, param4:DisplayObject = null, param5:Boolean = true)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.enableDoubleClick(this);
		 ExaltManager.instance.addEventListener(ExaltManager.EQUIP_MOVE,this.equipMoveHandler);
		 ExaltManager.instance.addEventListener(ExaltManager.EQUIP_MOVE2,this.equipMoveHandler2);
      }
      
      private function equipMoveHandler(param1:ExaltEvent) : void
      {
         var _loc2_:ExaltEvent = null;
         if(info == param1.info)
         {
            return;
         }
         if(Boolean(info))
         {
            _loc2_ = new ExaltEvent(ExaltManager.EQUIP_MOVE2);
            _loc2_.info = info as InventoryItemInfo;
            _loc2_.moveType = 3;
			ExaltManager.instance.dispatchEvent(_loc2_);
         }
         info = param1.info;
      }
      
      private function equipMoveHandler2(param1:ExaltEvent) : void
      {
         if(info != param1.info || param1.moveType != 2)
         {
            return;
         }
         info = null;
      }
      
      protected function __doubleClickHandler(param1:InteractiveEvent) : void
      {
         if(!info)
         {
            return;
         }
         SoundManager.instance.play("008");
         var _loc2_:ExaltEvent = new ExaltEvent(ExaltManager.EQUIP_MOVE2);
         _loc2_.info = info as InventoryItemInfo;
         _loc2_.moveType = 2;
		 ExaltManager.instance.dispatchEvent(_loc2_);
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         removeEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         removeEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.disableDoubleClick(this);
		 ExaltManager.instance.removeEventListener(ExaltManager.EQUIP_MOVE,this.equipMoveHandler);
		 ExaltManager.instance.removeEventListener(ExaltManager.EQUIP_MOVE2,this.equipMoveHandler2);
      }
      
      protected function __clickHandler(param1:InteractiveEvent) : void
      {
         SoundManager.instance.play("008");
         dragStart();
      }
      
      public function clearInfo() : void
      {
         var _loc1_:ExaltEvent = null;
         if(Boolean(info))
         {
            _loc1_ = new ExaltEvent(ExaltManager.EQUIP_MOVE2);
            _loc1_.info = info as InventoryItemInfo;
            _loc1_.moveType = 2;
			ExaltManager.instance.dispatchEvent(_loc1_);
         }
      }
	  
//	  override public function set info(param1:ItemTemplateInfo) : void
//	  {
////		  if(_info == param1 && !_info)
////		  {
////			  return;
////		  }
//		  super.info = info;
////		  dispatchEvent(new Event(Event.CHANGE));
//	  }
   }
}
