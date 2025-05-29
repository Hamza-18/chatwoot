import CaptainTopicAPI from 'dashboard/api/captain/topic';
import { createStore } from './storeFactory';

export default createStore({
  name: 'CaptainTopic',
  API: CaptainTopicAPI,
});
