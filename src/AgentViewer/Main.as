import com.GameInterface.AgentSystem;
import com.GameInterface.DistributedValue;
import mx.utils.Delegate;
class AgentViewer.Main {

	private var AgentWindow:DistributedValue;
	public static function main(swfRoot:MovieClip):Void {
		var s_app = new Main(swfRoot);
		swfRoot.onLoad = function() {s_app.Load()};
		swfRoot.onUnload = function() {s_app.UnLoad()};
	}

	public function Main() {
		AgentWindow = DistributedValue.Create("agentSystem_window");
	}

	public function Load() {
		AgentWindow.SignalChanged.Connect(Hook, this);
	}

	public function UnLoad() {
		AgentWindow.SignalChanged.Disconnect(Hook, this);
	}
	private function Hook() {
		if (AgentWindow.GetValue()) {
			if (_global.GUI.AgentSystem.RosterIcon.prototype.LoadPortrait && _root.agentsystem.m_Window.m_Content.m_Roster) {
				if (!_global.GUI.AgentSystem.RosterIcon.prototype._UpdateVisuals) {
					_global.GUI.AgentSystem.RosterIcon.prototype._UpdateVisuals = _global.GUI.AgentSystem.RosterIcon.prototype.UpdateVisuals;
					_global.GUI.AgentSystem.RosterIcon.prototype.UpdateVisuals = function() {
						this._UpdateVisuals();
						if (!this.m_PortraitMode) {
							if (!AgentSystem.HasAgent(this.data.m_AgentId)){
								this.m_Name._visible = true;
							}
						}
					}
				}
				if (!_global.GUI.AgentSystem.RosterIcon.prototype._UpdatePortraitVisibility){
					_global.GUI.AgentSystem.RosterIcon.prototype._UpdatePortraitVisibility = _global.GUI.AgentSystem.RosterIcon.prototype.UpdatePortraitVisibility;
					_global.GUI.AgentSystem.RosterIcon.prototype.UpdatePortraitVisibility = function () {
						this.m_Frame.m_Portrait._visible = true;
						this.m_Frame.m_Unowned._visible = !this.m_Frame.m_Portrait._visible;
					}
				}
				for (var i in _root.agentsystem.m_Window.m_Content.m_Roster) {
					var agentIcon:MovieClip = _root.agentsystem.m_Window.m_Content.m_Roster[i];
					agentIcon["UpdateVisuals"]();
				}
				if (!_global.GUI.AgentSystem.Roster.prototype._OnAgentSelected){
					_global.GUI.AgentSystem.Roster.prototype._OnAgentSelected = _global.GUI.AgentSystem.Roster.prototype.OnAgentSelected;
					_global.GUI.AgentSystem.Roster.prototype.OnAgentSelected = function(event:Object){
						var agentData = this.m_TileList.dataProvider[this.m_TileList.selectedIndex];
						this.SignalAgentSelected.Emit(agentData);
					}
				}
			} else {
				setTimeout(Delegate.create(this, Hook), 50);
			}
		}
	}
}