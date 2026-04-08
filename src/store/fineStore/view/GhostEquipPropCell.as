package store.fineStore.view
{
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.DoubleClickManager;
   import com.pickgliss.utils.ObjectUtils;
   
   import flash.display.DisplayObject;
   
   import bagAndInfo.cell.BagCell;
   
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.SoundManager;
   
   import store.equipGhost.EquipGhostEvent;
   import store.equipGhost.EquipGhostManager;
   
   public class GhostEquipPropCell extends BagCell
   {
	  private var _type:String;
      
      public function GhostEquipPropCell(type: String, param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true, param4:DisplayObject = null, param5:Boolean = true)
      {
		 this._type = type;
         super(param1,param2,param3,param4,param5);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(Boolean(_tbxCount))
         {
            ObjectUtils.disposeObject(_tbxCount);
         }
         _tbxCount = ComponentFactory.Instance.creat("wishBeadMainView.itemCell.countTxt");
         _tbxCount.mouseEnabled = false;
         addChild(_tbxCount);
      }
	  
	  override public function set info(param1:ItemTemplateInfo) : void
	  {
		  if(this.type == EquipGhostManager.LUCK_TYPE)
		  {
			  EquipGhostManager.getInstance().chooseLuckyMaterial(param1 as InventoryItemInfo);
		  }
		  else if(this.type == EquipGhostManager.STONE_TYPE)
		  {
			  EquipGhostManager.getInstance().chooseStoneMaterial(param1 as InventoryItemInfo);
		  }
		  super.info = param1;
	  }
      
      override protected function initEvent() : void
      {
         super.initEvent();
         addEventListener(InteractiveEvent.CLICK,this.__clickHandler);
         addEventListener(InteractiveEvent.DOUBLE_CLICK,this.__doubleClickHandler);
         DoubleClickManager.Instance.enableDoubleClick(this);
         EquipGhostManager.instance.addEventListener(EquipGhostManager.ITEM_MOVE + this.type,this.itemMoveHandler);
         EquipGhostManager.instance.addEventListener(EquipGhostManager.ITEM_MOVE2 + this.type,this.itemMoveHandler2);
      }
      
      private function itemMoveHandler(param1:EquipGhostEvent) : void
      {
         var _loc2_:EquipGhostEvent = null;
         if(info == param1.info)
         {
            return;
         }
		 
         if(Boolean(info)) // replace current item, need to move current back to baglist
         {
            _loc2_ = new EquipGhostEvent(EquipGhostManager.ITEM_MOVE2 + this.type);
            _loc2_.info = info as InventoryItemInfo;
            _loc2_.moveType = 3;
            EquipGhostManager.instance.dispatchEvent(_loc2_);
         }
		 info = param1.info;
      }
      
      private function itemMoveHandler2(param1:EquipGhostEvent) : void
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
         var _loc2_:EquipGhostEvent = new EquipGhostEvent(EquipGhostManager.ITEM_MOVE2 + this.type);
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
         EquipGhostManager.instance.removeEventListener(EquipGhostManager.ITEM_MOVE + this.type,this.itemMoveHandler);
         EquipGhostManager.instance.removeEventListener(EquipGhostManager.ITEM_MOVE2 + this.type,this.itemMoveHandler2);
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
            _loc1_ = new EquipGhostEvent(EquipGhostManager.ITEM_MOVE2 + this.type);
            _loc1_.info = info as InventoryItemInfo;
            _loc1_.moveType = 2;
            EquipGhostManager.instance.dispatchEvent(_loc1_);
         }
      }
	  
	  public function get type(): String
	  {
		  return this._type;
	  }
   }
}
