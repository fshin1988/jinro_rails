import Vue from 'vue/dist/vue.esm';
import axios from 'axios';
axios.defaults.headers['X-CSRF-TOKEN'] = $('meta[name=csrf-token]').attr('content')
import Switch from '../components/switch.vue';
import Notice from '../components/notice.vue';
import Alert from '../components/alert.vue';
import Timer from '../components/timer.vue';

new Vue({
  el: '#room-root',
  data: {
    chatDisplay: true,
    noticeDisplay: false,
    noticeMessage: "",
    alertDisplay: false,
    alertMessage: "",
    villageId: villageId,
    initialRemainingTime: 5,
    recordId: record ? record.id : "",
    voteSelected: record ? record.vote_target_id : "",
    attackSelected: record ? record.attack_target_id : "",
    divineSelected: record ? record.divine_target_id : "",
    guardSelected: record ? record.guard_target_id : ""
  },
  created: function() {
    this.setInitialRemainingTime()
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
    resetMessage: function() {
      this.noticeDisplay = false
      this.alertDisplay = false
    },
    setInitialRemainingTime: function() {
      axios.get('/api/v1/villages/' + this.villageId + '/remaining_time')
        .then(res => {
          this.initialRemainingTime = res.data.remaining_time
        });
    },
    goNextDay: function() {
      console.log("it's next day!!")
    }
  },
  components: {
    'switch-component': Switch,
    'notice-component': Notice,
    'alert-component': Alert,
    'timer-component': Timer
  }
});
