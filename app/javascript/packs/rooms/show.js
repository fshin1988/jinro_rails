import Vue from 'vue/dist/vue.esm';
import axios from 'axios';
axios.defaults.headers['X-CSRF-TOKEN'] = $('meta[name=csrf-token]').attr('content')
import Switch from '../components/switch.vue';
import Notice from '../components/notice.vue';
import Alert from '../components/alert.vue';
import Info from '../components/info.vue';
import Timer from '../components/timer.vue';

new Vue({
  el: '#room-root',
  data: {
    chatDisplay: true,
    noticeDisplay: false,
    noticeMessage: "",
    alertDisplay: false,
    alertMessage: "",
    infoDisplay: false,
    infoMessages: [],
    villageId: village.id,
    villageStatus: village.status,
    initialRemainingTime: 5,
    recordId: record ? record.id : "",
    voteSelected: record ? record.vote_target_id : "",
    attackSelected: record ? record.attack_target_id : "",
    divineSelected: record ? record.divine_target_id : "",
    guardSelected: record ? record.guard_target_id : ""
  },
  created: function() {
    if(this.villageStatus === "in_play") {
      this.setInitialRemainingTime()
    }
  },
  methods: {
    setVoteTarget: function() {
      axios.put('/api/v1/records/' + this.recordId, { record: { vote_target_id: this.voteSelected } })
        .then(res => {
          this.setNotice("投票先をセットしました")
        }, (error) => {
          this.setAlert("エラーが発生しました")
        });
    },
    setAttackTarget: function() {
      axios.put('/api/v1/records/' + this.recordId, { record: { attack_target_id: this.attackSelected } })
        .then(res => {
          this.setNotice("襲撃先をセットしました")
        }, (error) => {
          this.setAlert("エラーが発生しました")
        });
    },
    setDivineTarget: function() {
      axios.put('/api/v1/records/' + this.recordId, { record: { divine_target_id: this.divineSelected } })
        .then(res => {
          this.setNotice("占い先をセットしました")
        }, (error) => {
          this.setAlert("エラーが発生しました")
        });
    },
    setGuardTarget: function() {
      axios.put('/api/v1/records/' + this.recordId, { record: { guard_target_id: this.guardSelected } })
        .then(res => {
          this.setNotice("護衛先をセットしました")
        }, (error) => {
          this.setAlert("エラーが発生しました")
        });
    },
    switchArea: function() {
      this.chatDisplay = !this.chatDisplay
    },
    setNotice: function(message) {
      this.noticeDisplay = true
      this.noticeMessage = message
    },
    setAlert: function(message) {
      this.alertDisplay = true
      this.alertMessage = message
    },
    setInfo: function(messages) {
      this.infoDisplay = true
      this.infoMessages = messages
    },
    resetMessage: function() {
      this.noticeDisplay = false
      this.alertDisplay = false
      this.infoDisplay = false
    },
    setInitialRemainingTime: function() {
      axios.get('/api/v1/villages/' + this.villageId + '/remaining_time')
        .then(res => {
          this.initialRemainingTime = res.data.remaining_time
        });
    },
    goNextDay: function() {
      axios.get('/api/v1/villages/' + this.villageId + '/go_next_day')
    },
    showDivineResult: function() {
      axios.get('/api/v1/villages/' + this.villageId + '/divine')
        .then(res => {
          this.setInfo(res.data.messages)
        }, (error) => {
          this.setAlert("エラーが発生しました")
        });
    },
  },
  components: {
    'switch-component': Switch,
    'notice-component': Notice,
    'info-component': Info,
    'alert-component': Alert,
    'timer-component': Timer
  }
});
